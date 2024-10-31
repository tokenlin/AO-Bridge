import { useState, useEffect } from "react";
import { ethers } from "ethers";

export const useWallet = () => {
    const [account, setAccount] = useState<string | null>(null);
    const [signer, setSigner] = useState<ethers.JsonRpcSigner | null>(null);

    const connectWallet = async () => {
        if (window.ethereum) {
            try {
                const newProvider = new ethers.BrowserProvider(window.ethereum);
                const accounts = await newProvider.send("eth_requestAccounts", []);
                
                if (accounts.length > 0) {
                    setAccount(accounts[0]);
                    const newSigner = await newProvider.getSigner();
                    setSigner(newSigner);
                }
            } catch (error) {
                console.error("Initialization error:", error);
            }
        } else {
            alert("MetaMask is not installed");
        }
    };

    // 可选：在组件挂载时检查是否已经连接钱包
    useEffect(() => {
        if (window.ethereum) {
            const checkAccount = async () => {
                const newProvider = new ethers.BrowserProvider(window.ethereum);
                const accounts = await newProvider.send("eth_accounts", []);
                if (accounts.length > 0) {
                    setAccount(accounts[0]);
                    const newSigner = await newProvider.getSigner();
                    setSigner(newSigner);
                }
            };
            checkAccount();
        }
    }, []);

    return { account, signer, connectWallet };
};
