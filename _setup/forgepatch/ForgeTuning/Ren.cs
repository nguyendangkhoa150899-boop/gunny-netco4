using System;
using System.Configuration;
using System.Reflection;

namespace ForgeTuning
{
    /// <summary>
    /// Tiem ren 100% (cuong hoa, hop thanh, dat vang, tang cap, chien hon, tiem nang, duc lo...). Patcher thay loi goi
    /// random.Next(...) trong cac handler cua Game.Server.dll bang cac ham duoi day (cung kieu stack: doi tuong random + tham so).
    /// Bat/tat bang appSettings cua Road.Service.exe.config, sua xong restart Road:
    ///   Forge100 = 1   moi lan deu thanh cong / ra so toi da
    ///   Forge100 = 0   (hoac khong co khoa) chay y nhu game goc: goi lai random.Next that
    /// </summary>
    public static class Ren
    {
        private static bool Bat
        {
            get
            {
                try
                {
                    var v = ConfigurationManager.AppSettings["Forge100"];
                    return v == "1" || string.Equals(v, "true", StringComparison.OrdinalIgnoreCase);
                }
                catch { return false; }
            }
        }

        // goi lai random.Next cua doi tuong goc (System.Random / ThreadSafeRandom / RandomSafe) khi tat
        private static int Goc(object r, Type[] kieu, object[] ts)
        {
            MethodInfo m = r.GetType().GetMethod("Next", BindingFlags.Instance | BindingFlags.Public, null, kieu, null);
            return (int)m.Invoke(r, ts);
        }
        private static readonly Type[] K1 = { typeof(int) };
        private static readonly Type[] K2 = { typeof(int), typeof(int) };

        /// <summary>thay random.Next(max) trong phep so "ti le &gt; rnd" / "ti le &gt;= rnd": tra -1 =&gt; luon dung</summary>
        public static int Qua1(object r, int max) => Bat ? -1 : Goc(r, K1, new object[] { max });

        /// <summary>thay random.Next(min, max) trong phep so "x &gt;= rnd": tra 0 =&gt; luon dung (x khong am)</summary>
        public static int Qua2(object r, int min, int max) => Bat ? 0 : Goc(r, K2, new object[] { min, max });

        /// <summary>thay random.Next(min, max) khi quay chi so / diem: tra so lon nhat Next co the ra (max - 1)</summary>
        public static int Max2(object r, int min, int max) => Bat ? (max > min ? max - 1 : min) : Goc(r, K2, new object[] { min, max });
    }
}
