const FlashloanProvider = artifacts.require('FlashloanProvider2.sol');
const FlashloanUser = artifacts.require('FlashloanUser2.sol');
const Dai = artifacts.require('mocks/Dai.sol')

contract('Flashloan', (accounts) => {
    const user = accounts[0];
    let flashloanProvider;
    let flashloanUser;
    let dai;
    const INPUT = 'Sergi'

    beforeEach(async () => {
        // contract instances
        dai = await Dai.new();
        flashloanProvider = await FlashloanProvider.new([dai.address]);
        flashloanUser = await FlashloanUser.new();

        // transfer 1000 DAIs to Flashloan contract
        await dai.faucet(flashloanProvider.address, web3.utils.toWei('5000'));
        const balanceFlashloan = await dai.balanceOf(flashloanProvider.address);
        console.log('Balance in Flashloan:', balanceFlashloan.toString());

    });

    it.only('should update the output', async () => {

        // call flashloan
        await flashloanUser.startFlashloan(
            flashloanProvider.address,
            web3.utils.toWei('1000'),
            dai.address,
            { from: user }
        );

        // check output in flashloan user contract
        const textAfter = await flashloanUser.output1();
        console.log(await flashloanUser.output1());
        console.log(await flashloanUser.output2());
    });

});