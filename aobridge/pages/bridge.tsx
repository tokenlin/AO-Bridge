import React, { useState } from 'react';
import { Card, Input, Button, Space, Typography, Spin } from "antd";
import { ethers } from 'ethers';
import Header from "@/components/Header";
import styles from "./bridge.module.css";

import { useWallet } from './api/useWallet';
import { BridgeTtansaction } from "./api/bridge";

const { Text } = Typography;
const { TextArea } = Input;

const hexToString = (hex: string): string => {
    // 移除开头的 "0x"
    const cleanedHex = hex.startsWith('0x') ? hex.slice(2) : hex;

    // 将 hex 转换为 Buffer，然后再转换为字符串
    const buffer = Buffer.from(cleanedHex, 'hex');
    return buffer.toString('utf-8');
};

export default function Bridge() {
    const { signer, setSigner } = useWallet();
    const [result, setResult] = useState("");
    const [proof, setProof] = useState("");
    const [loading, setLoading] = useState(false);

    const handleBridge = async () => {
        setLoading(true);
        try {
            const { s_lastRequestId, s_lastResponse, s_lastError, txReceipt } = await BridgeTtansaction(signer, proof);
            // 在这里使用这三个变量
            if (s_lastResponse === "0x") {
                setResult("error");
            } else {
                setResult(hexToString(s_lastResponse));
            }
            console.log("Received values:");
            console.log("s_lastRequestId:", s_lastRequestId);
            console.log("s_lastResponse:", s_lastResponse);
            console.log("s_lastError:", s_lastError);
            console.log("Transaction Receipt:", txReceipt);
        } catch (error) {
            console.error("Error during bridge operation:", error);
        } finally {
            setLoading(false);
        }
    };
    return (
        <div>
            <Header />
            {loading && (
                <div className={styles.spin}>
                    <Spin tip="Loading..." />
                </div>
            )}
            <Card title="Bridge" className={styles.card}>
                <TextArea className={styles.input}
                    placeholder="proof"
                    maxLength={400}
                    showCount
                    // variant="borderless"
                    // type="number"
                    onChange={(e) => setProof(e.target.value)}
                />
                <Space className={styles.space}>
                    <Text>
                        Result: {result}
                    </Text>
                </Space>
                <Button type="primary"  disabled={proof.length <= 50}  size="large" block className={styles.button} onClick={handleBridge}>
                    Bridge
                </Button>
            </Card>
        </div>
    );
}