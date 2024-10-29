const {dryrun } =require("@permaweb/aoconnect");

const proof = "0x3e0a1130170986a28844d9d70c73fcceef2f6feecee41f5296dcce38daaf4a6579be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8d26326f1c17b5a07a1dcb3f417201003d4643bb436f9cefe8c5d813fdf8b56596d11b37ef4fc909ae1ec6c63584f99843f04ea9466730f8e58950c8c7262e6933ca3dd37304995604f567517e8c6e6074de37eab843f91475f713bd062067e61"


const getData = async() => {
    // // old aos
    // let result;
    // try{
    //     result = await dryrun({
    //         process: "OKo3TSifCu4Q_4_fUo7XrAQq9_WaDuYzKaxoEFY4VBw",  // from Kevin
    //         data: proof,
    //         tags: [{name: 'Action', value: 'Verify'}]
    //     });
    //     console.log(result);
    //     console.log();
    //     console.log(result.Messages[0].Data);

    // }catch(error){
    //     console.log("getDataFromAO --> ERR:", error);
    // }



    // new aos
    let result;
    try{
        result = await dryrun({
            process: "5i70cOWYaQJ_4mVXUdqOZ_1Orx6K8356UG5LwDxc4KU",  // from "Montreal"
            data: proof,
            tags: [{name: 'Action', value: 'proofVerify'}]
        });
        console.log(result);
        console.log();
        console.log(result.Messages[0].Data);

    }catch(error){
        console.log("getDataFromAO --> ERR:", error);
    }

}

getData();
