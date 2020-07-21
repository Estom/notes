


async function run(){
    var a=1;
    for(var i=0;i<1000000000;i++){
        a++;
    }
    console.log("run finish");
    return "run return";
}

async function run2(){
    console.log(await run());
    console.log("run2 finish")
    return "run2 return";
}

async function run3(){
    
    console.log(await run2());
    return "run3 return";
}
run3();
