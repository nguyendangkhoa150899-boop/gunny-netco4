using System;
using System.Configuration;

namespace BotTuning
{
    /// <summary>
    /// Can bang bot PvP (RingStation AutoBot). Patcher chen loi goi vao:
    ///   Game.Server.dll  RingStationMgr.CreateAutoBot(GamePlayer,...) / GetAutoBot  -> SucManh, KGoc, KMau, ChiaGoc
    ///   Game.Logic.dll   BotCommand.HandleCommand (truoc ShootPoint)                  -> Lech
    /// Tham so doc tu appSettings cua exe dang chay (Road.Service.exe.config / Fighting.Service.exe.config), sua xong restart:
    ///   BotPowerPercent    90   bot = 90% chi so nguoi choi duoc ghep
    ///   BotHitPercent      70   % luot ban nham chuan (10 luot trung ~7)
    ///   BotMissMin         90   luot truot: lech toi thieu (pixel)
    ///   BotMissMax         180  luot truot: lech toi da (pixel)
    /// </summary>
    public static class Bot
    {
        [ThreadStatic] private static Random _r;
        private static Random R => _r ?? (_r = new Random(Guid.NewGuid().GetHashCode()));

        private static double Cfg(string key, double macDinh)
        {
            try
            {
                var v = ConfigurationManager.AppSettings[key];
                double d;
                if (!string.IsNullOrEmpty(v) && double.TryParse(v, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d)) return d;
            }
            catch { }
            return macDinh;
        }

        private static double PhanTram => Math.Max(10, Math.Min(150, Cfg("BotPowerPercent", 90))) / 100.0;

        /// <summary>thay "x / 3" (chi so nguyen): x * BotPowerPercent / 100</summary>
        public static int SucManh(int v) => (int)Math.Round(v * PhanTram);

        /// <summary>thay hang so 0.0 trong "goc - 0.0 * goc / 3.0": tra (1 - p) * 3 => ket qua = goc * p</summary>
        public static double KGoc() => (1 - PhanTram) * 3.0;

        /// <summary>thay hang so 0.0 trong "mau - 0.0 * mau / 1.65": tra (1 - p) * 1.65 => ket qua = mau * p</summary>
        public static double KMau() => (1 - PhanTram) * 1.65;

        /// <summary>thay so chia 2.0 / 1.65 trong GetAutoBot: chia cho 1/p => ket qua = goc * p</summary>
        public static double ChiaGoc() => 1.0 / PhanTram;

        // 1 luot ban co the goi Lech 1-3 lan (dao cu 3 tia): cac lan goi sat nhau cua cung 1 bot dung chung ket qua trung/truot
        private static readonly object _k = new object();
        private static int _lastTick, _lastTu = int.MinValue, _lastLech;

        /// <summary>
        /// TI LE TRUNG theo luot (vd 7/10): BotHitPercent % luot nham chuan (giu diem nham goc cua game),
        /// con lai co tinh ban truot: lech BotMissMin..BotMissMax pixel sang trai/phai ngau nhien.
        /// x = diem nham, tu = x cua bot (nhan dien bot trong luot).
        /// </summary>
        public static int Lech(int x, int tu)
        {
            lock (_k)
            {
                int now = Environment.TickCount;
                if (tu == _lastTu && unchecked(now - _lastTick) < 1500) { _lastTick = now; return x + _lastLech; }
                int lech = 0;
                if (R.Next(100) >= Cfg("BotHitPercent", 70))
                {
                    int mn = (int)Cfg("BotMissMin", 90), mx = Math.Max(mn, (int)Cfg("BotMissMax", 180));
                    lech = R.Next(mn, mx + 1) * (R.Next(2) == 0 ? -1 : 1);
                }
                _lastTu = tu; _lastTick = now; _lastLech = lech;
                return x + lech;
            }
        }
    }
}
