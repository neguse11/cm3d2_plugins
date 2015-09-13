using Mono.Cecil;
using Mono.Cecil.Cil;
using System;
using System.IO;
using System.Linq;

internal static class PatcherHelper
{
    public delegate void InsertInstDelegate(Instruction newInst);

    public static AssemblyDefinition GetAssemblyDefinition(ReiPatcher.Patch.PatcherArguments args, string assemblyName)
    {
        var directoryName = Path.GetDirectoryName(args.Location);
        var filename = Path.Combine(directoryName, assemblyName);
        AssemblyDefinition ad = AssemblyDefinition.ReadAssembly(filename);
        if (ad == null)
        {
            Console.WriteLine("{0} not found", assemblyName);
            throw new Exception();
        }
        return ad;
    }

    public static MethodDefinition GetMethod(TypeDefinition type, string methodName)
    {
        return type.Methods.FirstOrDefault(m => m.Name == methodName);
    }

    public static MethodDefinition GetMethod(TypeDefinition type, string methodName, params string[] args)
    {
        for (int i = 0; i < type.Methods.Count; i++)
        {
            MethodDefinition m = type.Methods[i];
            if (m.Name == methodName && m.Parameters.Count == args.Length)
            {
                bool b = true;
                for (int j = 0; j < args.Length; j++)
                {
                    if (m.Parameters[j].ParameterType.FullName != args[j])
                    {
                        b = false;
                        break;
                    }
                }
                if (b)
                {
                    return m;
                }
            }
        }
        return null;
    }

    public static void SetHook(
        HookType hookType,
        AssemblyDefinition targetAssembly, string targetTypeName, string targetMethodName,
        AssemblyDefinition calleeAssembly, string calleeTypeName, string calleeMethodName)
    {
        TypeDefinition calleeTypeDefinition = calleeAssembly.MainModule.GetType(calleeTypeName);
        if (calleeTypeDefinition == null)
        {
            Console.WriteLine("Error ({0}) : {1} is not found", calleeAssembly.Name, calleeTypeName);
            throw new Exception();
        }

        MethodDefinition calleeMethod = GetMethod(calleeTypeDefinition, calleeMethodName);
        if (calleeMethod == null)
        {
            Console.WriteLine("Error ({0}) : {1}.{2} is not found", calleeAssembly.Name, calleeTypeName, calleeMethodName);
            throw new Exception();
        }

        TypeDefinition targetTypeDefinition = targetAssembly.MainModule.GetType(targetTypeName);
        if (targetTypeDefinition == null)
        {
            Console.WriteLine("Error ({0}) : {1} is not found", targetAssembly.Name, targetTypeName);
            throw new Exception();
        }

        MethodDefinition targetMethod = GetMethod(targetTypeDefinition, targetMethodName);
        if (targetMethod == null)
        {
            Console.WriteLine("Error ({0}) : {1}.{2} is not found", targetAssembly.Name, targetTypeName, targetMethodName);
            throw new Exception();
        }
        HookMethod(hookType, targetAssembly.MainModule, targetMethod, calleeMethod);
    }

    public static void HookMethod(
        HookType hookType,
        ModuleDefinition targetModule, MethodDefinition targetMethod,
        MethodDefinition calleeMethod)
    {
        ILProcessor l = targetMethod.Body.GetILProcessor();
        Instruction instInsertPoint = targetMethod.Body.Instructions.First();

        if (hookType == HookType.PostCall)
        {
            instInsertPoint = targetMethod.Body.Instructions.Last();
        }

        InsertInstDelegate o = newInst =>
        {
            l.InsertBefore(instInsertPoint, newInst);
        };

        int n = targetMethod.Parameters.Count + (targetMethod.IsStatic ? 0 : 1);
        for (int i = 0; i < n; i++)
        {
            if (i == 0)
            {
                o(l.Create(OpCodes.Ldarg_0));
            }
            else
            {
                // ref �Q�Ƃɂ������ꍇ�� OpCodes.Ldarga �ɂ��邱��
                o(l.Create(OpCodes.Ldarg, i));
            }
        }
        o(l.Create(OpCodes.Call, targetModule.Import(calleeMethod)));

        // PreJump�̏ꍇ�͌��̏������s��Ȃ��悤�ɁA���̂܂�Ret����
        if (hookType == HookType.PreJump)
        {
            o(l.Create(OpCodes.Ret));
        }
    }

    public enum HookType
    {
        PreJump,        // �����\�b�h�̐擪�ŁA�u�������惁�\�b�h�փW�����v���A���̃��\�b�h�̏����͈�؍s�킸�ɏI������
        PreCall,        // �����\�b�h�̐擪�ŁA�u�������惁�\�b�h���R�[�����A���̌�ʏ�ʂ茳�̃��\�b�h�̏������s��
        PostCall,       // �����\�b�h�̏����������������ƁA���^�[�����钼�O�Œu�������惁�\�b�h���Ăяo��
    }
}
