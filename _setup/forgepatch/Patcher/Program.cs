// Tiem ren 100%: thay random.Next(...) trong cac handler tiem ren cua Game.Server.dll bang ForgeTuning.Ren.*
//   dotnet run -- scan  <Game.Server.dll>                         liet ke moi loi goi *Random*.Next trong cac handler
//   dotnet run -- patch <Game.Server.dll> <ForgeTuning.dll> <ra>  ghi <ra>/Game.Server.dll + ForgeTuning.dll
// Dau vao la Game.Server.dll DANG CHAY o C:\Gunny92\Server\road (da co ban va bot). Dat ket qua canh Road.Service.exe, restart Road.
// Bat/tat: Forge100 trong Road.Service.exe.config. Hoan tac han: chep lai Game.Server.dll.bak-forge.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Mono.Cecil;
using Mono.Cecil.Cil;

static class Program
{
    // handler -> (so tham so cua Next, ham thay). So lan thay phai dung "SoLan", lech la dung lai (DLL khac ban da khao sat).
    class Vi { public string Lop; public int SoTs; public string Ham; public int SoLan; public string Ghi; }
    static readonly Vi[] BANG =
    {
        new Vi { Lop = "ItemStrengthenHandler", SoTs = 1, Ham = "Qua1", SoLan = 1, Ghi = "cuong hoa: num7 > random.Next(10000)" },
        new Vi { Lop = "ItemComposeHandler",    SoTs = 1, Ham = "Qua1", SoLan = 1, Ghi = "hop thanh: num3 > random.Next(100)" },
        new Vi { Lop = "WishBeadEquipHandler",  SoTs = 1, Ham = "Qua1", SoLan = 1, Ghi = "dat vang: WishBeadRate >= random.Next(100000)" },
        new Vi { Lop = "ItemAdvanceHandler",    SoTs = 2, Ham = "Qua2", SoLan = 3, Ghi = "tang cap: StrengthenExp >= random.Next(a,b) x3" },
        new Vi { Lop = "EquipGhostHandler",     SoTs = 2, Ham = "Qua2", SoLan = 1, Ghi = "chien hon: ti le*2000 >= random.Next(0,100000)" },
        new Vi { Lop = "LatentEnergyHandler",   SoTs = 2, Ham = "Max2", SoLan = -1, Ghi = "tiem nang: chi so = random.Next(P2,P3) -> toi da" },
        new Vi { Lop = "OpenFiveSixHoleHandler",SoTs = 2, Ham = "Max2", SoLan = -1, Ghi = "duc lo 5/6: diem = random.Next(P7,P8) -> toi da" },
        new Vi { Lop = "FusionMgr",             SoTs = 1, Ham = "Qua1", SoLan = 3, Ghi = "dung luyen: rand.Next(need) < TotalRate, ti le > rand.Next(100) (ra mon tot hon)" },
        new Vi { Lop = "RefineryMgr",           SoTs = 1, Ham = "Qua1", SoLan = 1, Ghi = "luyen hoa / gia cong: rand.Next(100) < defaultprobability" },
    };

    static bool LaNext(Instruction x, out MethodReference mr)
    {
        mr = null;
        if (x.OpCode != OpCodes.Callvirt && x.OpCode != OpCodes.Call) return false;
        mr = x.Operand as MethodReference;
        return mr != null && mr.Name == "Next" && mr.DeclaringType.Name.IndexOf("Random", StringComparison.OrdinalIgnoreCase) >= 0 && mr.HasThis;
    }

    static IEnumerable<TypeDefinition> MoiLop(ModuleDefinition m)
    {
        foreach (var t in m.Types) { yield return t; foreach (var n in t.NestedTypes) yield return n; }
    }

    static string Doan(MethodBody b, int i)
    {
        var ins = b.Instructions; var s = new List<string>();
        for (int k = Math.Max(0, i - 3); k <= Math.Min(ins.Count - 1, i + 3); k++) s.Add((k == i ? ">>" : "  ") + ins[k].OpCode + " " + (ins[k].Operand is MethodReference m ? m.Name : ins[k].Operand?.ToString()));
        return string.Join(" | ", s);
    }

    static int Main(string[] a)
    {
        if (a.Length >= 2 && a[0] == "scan")
        {
            var mod = ModuleDefinition.ReadModule(a[1]);
            string loc = a.Length > 2 ? a[2] : null;   // scan <dll> <chu trong ten lop>: quet ca lop khong phai Handler
            foreach (var t in MoiLop(mod).Where(t => loc == null ? t.Name.EndsWith("Handler") : t.FullName.IndexOf(loc, StringComparison.OrdinalIgnoreCase) >= 0))
                foreach (var me in t.Methods.Where(x => x.HasBody))
                    for (int i = 0; i < me.Body.Instructions.Count; i++)
                        if (LaNext(me.Body.Instructions[i], out var mr))
                            Console.WriteLine($"{t.FullName}.{me.Name}  {mr.DeclaringType.Name}.Next/{mr.Parameters.Count}  {Doan(me.Body, i)}");
            return 0;
        }
        if (a.Length < 4 || a[0] != "patch") { Console.WriteLine("dung: Patcher scan <dll> | Patcher patch <Game.Server.dll> <ForgeTuning.dll> <ra>"); return 1; }

        string src = a[1], tuningPath = a[2], outDir = a[3];
        Directory.CreateDirectory(outDir);
        var res = new DefaultAssemblyResolver(); res.AddSearchDirectory(Path.GetDirectoryName(Path.GetFullPath(src))); res.AddSearchDirectory(Path.GetDirectoryName(Path.GetFullPath(tuningPath)));
        var gs = ModuleDefinition.ReadModule(src, new ReaderParameters { AssemblyResolver = res });
        var tuning = ModuleDefinition.ReadModule(tuningPath);
        var ren = tuning.Types.Single(t => t.FullName == "ForgeTuning.Ren");

        bool sai = false;
        foreach (var v in BANG)
        {
            var lop = MoiLop(gs).Where(t => t.Name == v.Lop).ToList();
            if (lop.Count != 1) { Console.WriteLine($"{v.Lop}: thay {lop.Count} lop, BO QUA"); sai = true; continue; }
            var ham = gs.ImportReference(ren.Methods.Single(m => m.Name == v.Ham));
            int n = 0;
            foreach (var me in lop[0].Methods.Where(x => x.HasBody))
                foreach (var x in me.Body.Instructions)
                    if (LaNext(x, out var mr) && mr.Parameters.Count == v.SoTs) { x.OpCode = OpCodes.Call; x.Operand = ham; n++; }
            bool ok = v.SoLan < 0 ? n > 0 : n == v.SoLan;
            Console.WriteLine($"{v.Lop}: thay {n} loi goi Next/{v.SoTs} -> Ren.{v.Ham}  ({v.Ghi}){(ok ? "" : "  <== SAI MAU")}");
            if (!ok) sai = true;
        }
        if (sai) { Console.WriteLine("Co cho khong khop mau, KHONG ghi file. Chay 'scan' de xem lai."); return 2; }
        gs.Write(Path.Combine(outDir, "Game.Server.dll"));
        File.Copy(tuningPath, Path.Combine(outDir, "ForgeTuning.dll"), true);
        Console.WriteLine("XONG -> " + outDir);
        return 0;
    }
}
