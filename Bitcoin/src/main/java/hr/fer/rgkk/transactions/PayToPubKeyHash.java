package hr.fer.rgkk.transactions;


import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.crypto.TransactionSignature;
import org.bitcoinj.script.Script;
//my imports
import org.bitcoinj.core.ECKey;
import org.bitcoinj.script.ScriptBuilder;
import static org.bitcoinj.script.ScriptOpCodes.*;

public class PayToPubKeyHash extends ScriptTransaction {

    private final ECKey key;

    public PayToPubKeyHash(WalletKit walletKit, NetworkParameters parameters) {
        super(walletKit, parameters);
        this.key = new ECKey();
    }

    @Override
    public Script createLockingScript() {
        // TODO: Create Locking script
        return new ScriptBuilder()
                .op(OP_DUP)
                .op(OP_HASH160)
                .data(key.getPubKeyHash())
                .op(OP_EQUALVERIFY)
                .op(OP_CHECKSIG)
                .build();
    }

    @Override
    public Script createUnlockingScript(Transaction unsignedTransaction) {
        TransactionSignature txSig = sign(unsignedTransaction, key);
        return new ScriptBuilder()
                .data(txSig.encodeToBitcoin())
                .data(key.getPubKey())
                .build();
    }
}
