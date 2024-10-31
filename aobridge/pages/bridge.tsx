import React, { useState } from 'react';
import { Card, Input, Button, Space, Typography} from "antd";
import Header from "@/components/Header";
import styles from "./bridge.module.css";

import { ThirdwebProvider } from "thirdweb/react";
 

const { Text } = Typography;

export default function Bridge() {
    const [result, setResult] = useState("result");
    return (
        <div>
            <ThirdwebProvider>
            <Header />
            <Card title="Bridge" className={styles.card}>
                <Input className={styles.input}
                // variant="borderless"
                // type="number"
                // onChange={(e) => handleAmountAChange(e)}
                />
                <Space className={styles.space}>
                    <Text type="secondary">
                        {result}
                    </Text>
                </Space>
                <Button type="primary" size="large" block className={styles.button}>
                    Swap
                </Button>
            </Card>
            </ThirdwebProvider>
        </div>
    );
}