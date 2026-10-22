// Va Game.Logic.dll (ban nhung trong Road.Service.exe, Road chay pho ban): thoi gian ban moi luot trong PHO BAN = N giay.
// BaseGame.getTurnTime() map m_timeType 1..6 -> 8/10/12/16/21/31 giay (khong co 15/18) va gui xuong client trong goi luot moi
// (SendGameNextTurn); client dem nguoc dung so nay (ChangePlayerAction: turnTime > 0 thi dung). Server cho toi da
// (m_timeType + 20) giay (WaitLivingAttackingAction) nen N <= 20 an toan.
// Chen dau ham:  if (this is PVEGame) return N;   PvP (Fighting) khong doi.
// Dung: dotnet run --project _setup/turnpatch/Patcher -- <Game.Logic vao> <Game.Logic ra> <so giay>
using System;
using System.Linq;
using Mono.Cecil;
using Mono.Cecil.Cil;

class Program
{
    static int Main(string[] a)
    {
        if (a.Length != 3) { Console.WriteLine("dung: Patcher <Game.Logic vao> <ra> <so giay>"); return 1; }
        int giay = int.Parse(a[2]);
        if (giay < 5 || giay > 20) { Console.WriteLine("so giay 5..20 (server cho toi da timeType+20 giay)"); return 1; }
        var mod = ModuleDefinition.ReadModule(a[0], new ReaderParameters { ReadWrite = false, InMemory = true });
        var baseGame = mod.Types.FirstOrDefault(t => t.FullName == "Game.Logic.BaseGame");
        var pve = mod.Types.FirstOrDefault(t => t.FullName == "Game.Logic.PVEGame");
        var m = baseGame?.Methods.FirstOrDefault(x => x.Name == "getTurnTime" && x.Parameters.Count == 0);
        if (m == null || pve == null) { Console.WriteLine("KHONG THAY BaseGame.getTurnTime / PVEGame: dung lai"); return 2; }
        var il = m.Body.GetILProcessor();
        var dau = m.Body.Instructions[0];
        if (dau.OpCode == OpCodes.Ldarg_0 && m.Body.Instructions[1].OpCode == OpCodes.Isinst) { Console.WriteLine("DA VA ROI: dung lai (va tu ban goc)"); return 3; }
        // ldarg.0; isinst PVEGame; brfalse dau; ldc.i4 N; ret
        il.InsertBefore(dau, il.Create(OpCodes.Ldarg_0));
        il.InsertBefore(dau, il.Create(OpCodes.Isinst, pve));
        il.InsertBefore(dau, il.Create(OpCodes.Brfalse, dau));
        il.InsertBefore(dau, il.Create(OpCodes.Ldc_I4, giay));
        il.InsertBefore(dau, il.Create(OpCodes.Ret));
        mod.Write(a[1]);
        Console.WriteLine($"Da va getTurnTime: pho ban = {giay} giay -> {a[1]}");
        return 0;
    }
}
