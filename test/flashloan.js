const FlashloanProvider = artifacts.require('FlashloanProvider.sol');
const FlashloanUser = artifacts.require('FlashloanUser.sol');
const Dai = artifacts.require('mocks/Dai.sol')

contract('Flashloan', (accounts) => {
    const user = accounts[0];
    let flashloanProvider;
    let flashloanUser;
    let dai;

    beforeEach(async () => {
        // contract instances
        dai = await Dai.new();
        flashloanProvider = await FlashloanProvider.new([dai.address]);
        flashloanUser = await FlashloanUser.new();

        // transfer 1000 DAIs to Flashloan contract
        await dai.faucet(flashloanProvider.address, web3.utils.toWei('1000'));
        const balanceFlashloan = await dai.balanceOf(flashloanProvider.address);
        console.log('Balance in Flashloan:', balanceFlashloan.toString());

        // call flashloan
        await flashloanUser.startFlashloan(
            flashloanProvider.address,
            web3.utils.toWei('1000'),
            dai.address,
            //web3.utils.fromAscii('testing'),
            { from: user }
        );

    });

    it('should launch flashloan', async () => {
        assert(1 === 1);
    });

});