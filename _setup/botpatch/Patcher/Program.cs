// Va bot PvP: dotnet run -- <thu muc DLL Road da tach> <thu muc DLL Fighting da tach> <BotTuning.dll> <thu muc ra>
// Ra: <ra>/road/Game.Server.dll, <ra>/fight/Game.Logic.dll (+ BotTuning.dll). Dat canh Road.Service.exe / Fighting.Service.exe
// thi CLR nap file roi truoc ban Costura nhung trong exe. Hoan tac: xoa cac file nay roi restart.
using System;
using System.IO;
using System.Linq;
using Mono.Cecil;
using Mono.Cecil.Cil;
using Mono.Cecil.Rocks;

static class Program
{
    // sau SimplifyMacros: ldc.i4.3 -> ldc.i4 3, ldarg.2 -> ldarg <tham so>
    static bool IsI4(Instruction x, int v) => (x.OpCode == OpCodes.Ldc_I4 && (int)x.Operand == v) || (v == 2 && x.OpCode == OpCodes.Ldc_I4_2) || (v == 3 && x.OpCode == OpCodes.Ldc_I4_3);
    static bool IsArg(Instruction x, int idx) => (x.OpCode == OpCodes.Ldarg && x.Operand is ParameterDefinition p && p.Index == idx) || (idx == 1 && x.OpCode == OpCodes.Ldarg_2);

    static int Main(string[] a)
    {
        if (a.Length < 4) { Console.WriteLine("dung: Patcher <roadDir> <fightDir> <BotTuning.dll> <outDir>"); return 1; }
        string roadDir = a[0], fightDir = a[1], tuningPath = a[2], outDir = a[3];
        Directory.CreateDirectory(Path.Combine(outDir, "road"));
        Directory.CreateDirectory(Path.Combine(outDir, "fight"));
        var tuning = ModuleDefinition.ReadModule(tuningPath);
        var bot = tuning.Types.Single(t => t.FullName == "BotTuning.Bot");
        MethodDefinition M(string n) => bot.Methods.Single(m => m.Name == n);

        // ---------- Game.Server.dll (Road): suc manh bot ----------
        {
            var res = new DefaultAssemblyResolver(); res.AddSearchDirectory(roadDir); res.AddSearchDirectory(Path.GetDirectoryName(tuningPath));
            var mod = ModuleDefinition.ReadModule(Path.Combine(roadDir, "game.server.dll"), new ReaderParameters { AssemblyResolver = res });
            var rs = mod.Types.Single(t => t.FullName == "Game.Server.RingStation.RingStationMgr");
            var sucManh = mod.ImportReference(M("SucManh")); var kGoc = mod.ImportReference(M("KGoc"));
            var kMau = mod.ImportReference(M("KMau")); var chiaGoc = mod.ImportReference(M("ChiaGoc"));

            // CreateAutoBot(GamePlayer,int,int,int): "x / 3" (6 lan) -> SucManh(x); 4 hang so 0.0 -> KGoc x3, KMau x1
            var cab = rs.Methods.Single(m => m.Name == "CreateAutoBot" && m.Parameters.Count == 4);
            cab.Body.SimplifyMacros();
            var il = cab.Body.GetILProcessor(); var ins = cab.Body.Instructions;
            int nDiv = 0, nZero = 0;
            for (int i = 0; i < ins.Count - 1; i++)
            {
                if (IsI4(ins[i], 3) && ins[i + 1].OpCode == OpCodes.Div)
                { ins[i].OpCode = OpCodes.Call; ins[i].Operand = sucManh; il.Remove(ins[i + 1]); nDiv++; }
            }
            foreach (var x in ins.Where(x => x.OpCode == OpCodes.Ldc_R8 && (double)x.Operand == 0.0).ToList())
            { x.OpCode = OpCodes.Call; x.Operand = nZero < 3 ? kGoc : kMau; nZero++; }
            Console.WriteLine($"CreateAutoBot: thay {nDiv} phep chia 3, {nZero} hang so 0.0");
            if (nDiv != 6 || nZero != 4) { Console.WriteLine("SAI MAU, dung lai"); return 2; }

            // GetAutoBot(GamePlayer,int,int): "x / 2" (5 lan, int) -> SucManh; "/ 2.0" va "/ 1.65" -> chia ChiaGoc()
            cab.Body.OptimizeMacros();
            var gab = rs.Methods.Single(m => m.Name == "GetAutoBot" && m.Parameters.Count == 3);
            gab.Body.SimplifyMacros();
            il = gab.Body.GetILProcessor(); ins = gab.Body.Instructions;
            int nDiv2 = 0, nDbl = 0;
            for (int i = 0; i < ins.Count - 1; i++)
            {
                if (IsI4(ins[i], 2) && ins[i + 1].OpCode == OpCodes.Div)
                { ins[i].OpCode = OpCodes.Call; ins[i].Operand = sucManh; il.Remove(ins[i + 1]); nDiv2++; }
            }
            foreach (var x in ins.Where(x => x.OpCode == OpCodes.Ldc_R8 && ((double)x.Operand == 2.0 || (double)x.Operand == 1.65)).ToList())
            { x.OpCode = OpCodes.Call; x.Operand = chiaGoc; nDbl++; }
            Console.WriteLine($"GetAutoBot: thay {nDiv2} phep chia 2, {nDbl} so chia thuc");
            if (nDiv2 != 5 || nDbl != 4) { Console.WriteLine("SAI MAU, dung lai"); return 2; }
            gab.Body.OptimizeMacros();
            mod.Write(Path.Combine(outDir, "road", "Game.Server.dll"));
        }

        // ---------- Game.Logic.dll (Fighting): ban lech + chan lo hong ----------
        {
            var res = new DefaultAssemblyResolver(); res.AddSearchDirectory(fightDir); res.AddSearchDirectory(Path.GetDirectoryName(tuningPath));
            var mod = ModuleDefinition.ReadModule(Path.Combine(fightDir, "game.logic.dll"), new ReaderParameters { AssemblyResolver = res });
            var bc = mod.Types.Single(t => t.FullName == "Game.Logic.Cmd.BotCommand");
            var h = bc.Methods.Single(m => m.Name == "HandleCommand");
            var playerT = mod.Types.Single(t => t.FullName == "Game.Logic.Phy.Object.Player");
            MethodDefinition Getter(TypeDefinition t, string p)
            {
                for (var cur = t; cur != null; cur = cur.BaseType?.Resolve())
                {
                    var g = cur.Properties.FirstOrDefault(x => x.Name == p)?.GetMethod; if (g != null) return g;
                }
                return null;
            }
            var getX = mod.ImportReference(Getter(playerT, "X"));
            var getDetail = mod.ImportReference(Getter(playerT, "PlayerDetail"));
            var igp = getDetail.ReturnType.Resolve();
            var getChar = mod.ImportReference(Getter(igp, "PlayerCharacter"));
            var getBot = mod.ImportReference(Getter(getChar.ReturnType.Resolve(), "IsAutoBot"));
            var lech = mod.ImportReference(M("Lech"));
            h.Body.SimplifyMacros();
            var il = h.Body.GetILProcessor(); var ins = h.Body.Instructions;

            // 1. ban lech: trong loi goi player.ShootPoint(x, y, ...): sau "ldloc x" chen "ldarg player; callvirt get_X; call Lech"
            var shoot = ins.Where(x => (x.OpCode == OpCodes.Callvirt || x.OpCode == OpCodes.Call) && x.Operand is MethodReference mr && mr.Name == "ShootPoint").ToList();
            if (shoot.Count != 1) { Console.WriteLine("khong thay ShootPoint duy nhat: " + shoot.Count); return 2; }
            Instruction ldx = null;
            for (var p = shoot[0].Previous; p != null; p = p.Previous)
            {
                if (IsArg(p, 1) && p.Next.OpCode.Name.StartsWith("ldloc") && p.Next.Next.OpCode.Name.StartsWith("ldloc")) { ldx = p.Next; break; }
            }
            if (ldx == null) { Console.WriteLine("khong thay mau ldarg.2; ldloc x; ldloc y"); return 2; }
            il.InsertAfter(ldx, il.Create(OpCodes.Call, lech));
            il.InsertAfter(ldx, il.Create(OpCodes.Callvirt, getX));
            il.InsertAfter(ldx, il.Create(OpCodes.Ldarg_2));
            Console.WriteLine("BotCommand: chen Lech(x, player.X) truoc ShootPoint");

            // 2. chan lo hong: chi bot (PlayerCharacter.IsAutoBot) moi duoc dung lenh 143 -> dau ham: if(!IsAutoBot) return;
            var first = ins[0];
            il.InsertBefore(first, il.Create(OpCodes.Ldarg_2));
            il.InsertBefore(first, il.Create(OpCodes.Callvirt, getDetail));
            il.InsertBefore(first, il.Create(OpCodes.Callvirt, getChar));
            il.InsertBefore(first, il.Create(OpCodes.Callvirt, getBot));
            il.InsertBefore(first, il.Create(OpCodes.Brtrue, first));
            il.InsertBefore(first, il.Create(OpCodes.Ret));
            Console.WriteLine("BotCommand: chan nguoi that goi lenh 143");
            h.Body.OptimizeMacros();
            mod.Write(Path.Combine(outDir, "fight", "Game.Logic.dll"));
        }
        File.Copy(tuningPath, Path.Combine(outDir, "road", "BotTuning.dll"), true);
        File.Copy(tuningPath, Path.Combine(outDir, "fight", "BotTuning.dll"), true);
        Console.WriteLine("XONG -> " + outDir);
        return 0;
    }
}
