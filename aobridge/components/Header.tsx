import styles from "./header.module.css";
import { ConnectButton } from "thirdweb/react";

import { client } from "../pages/client";
import { createWallet } from "thirdweb/wallets";

export default function Header() {
    return (
        <div className={styles.header}>
            <div className={styles.title}>AO Bridge</div>
            <div>
                <ConnectButton client={client} wallets={[
                    createWallet("io.metamask"),
                    createWallet("com.coinbase.wallet"),
                    createWallet("me.rainbow"),
                ]} />
            </div>
        </div>
    );
}