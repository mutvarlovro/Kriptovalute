package hr.fer.rgkk.transactions;

import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.script.Script;
import org.bitcoinj.script.ScriptBuilder;

import static org.bitcoinj.script.ScriptOpCodes.*;

public class LogicalEquivalenceTransaction extends ScriptTransaction {

    public LogicalEquivalenceTransaction(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        return new ScriptBuilder()
                .op(OP_DUP)
                .op(OP_1ADD)
                .op(OP_1)
                .op(OP_3)
                .op(OP_WITHIN)
                .op(OP_IF)
                .op(OP_EQUAL)
                .op(OP_ELSE)
                .op(OP_2DROP)
                .op(OP_1)
                .op(OP_1)
                .op(OP_SUB)
                .op(OP_ENDIF)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedScript) {
        long x = 0;
        long y = 0;
        return new ScriptBuilder()
                .number(x)
                .number(y)
                .build();
    }
}
