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
    ///   BotAimErrorBase    6    do lech toi thieu (pixel)
    ///   BotAimErrorPer1000 30   cong them moi 1000 pixel khoang cach
    ///   BotAimErrorMax     45   do lech toi da
    ///   BotAimMissPercent  5    % phat ban truot han (lech x3)
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

        /// <summary>do lech diem nham: x muc tieu, tu = x cua bot. Lech deu trong [-e, e], thinh thoang truot han.</summary>
        public static int Lech(int x, int tu)
        {
            double kc = Math.Abs(x - tu);
            double e = Cfg("BotAimErrorBase", 6) + kc * Cfg("BotAimErrorPer1000", 30) / 1000.0;
            e = Math.Min(e, Cfg("BotAimErrorMax", 45));
            if (R.Next(100) < Cfg("BotAimMissPercent", 5)) e *= 3;
            int d = (int)Math.Round((R.NextDouble() * 2 - 1) * e);
            return x + d;
        }
    }
}
