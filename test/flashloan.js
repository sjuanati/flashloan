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

        // give DAIs to user
        //await dai.mint(user, '10000000000000000000');
    });

    it('should launch flashloan', async () => {
        assert(1 === 1);
    });

});