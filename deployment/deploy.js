const etherlime = require('etherlime');
const Articles = require('../build/Articles.json');
const ShishaCoin = require('../build/ShishaCoin.json');
const ShishaToken = require('../build/ShishaToken.json');
const ShishaPremiumCoin = require('../build/ShishaPremiumCoin.json');
const ShishaCrowdsale = require('../build/ShishaCrowdsale.json');

const infuraNetwork = 'rinkeby';
const userSecret = '104bbcf881bef9a1905baef3703627c3eb6aec3a3e3a0f02491c51ae05e4a65b';
const apiKey = 'a47ba9d3d9cd419392ffaea9786bde73';


const deployLocal = async (network, secret) => {

	const deployer = await new etherlime.EtherlimeGanacheDeployer();
	const articlesWrapper = await deployer.deploy(Articles);

	const tx = await articlesWrapper.contract.addArticle("tit", "desc", "pic");
	//console.log(articlesWrapper.contract);
	const articles = await articlesWrapper.contract.getArticles();
	console.log(articles);
};

const deployArticles = async (network, secret) => {

	//Articles deployer
	const deployer = await new etherlime.InfuraPrivateKeyDeployer(userSecret, infuraNetwork, apiKey);
	//const articlesWrapper = await deployer.deploy(Articles);
	//'0x4110D47063510dE66F6EB522e4c310b1B9A04372';
	const articlesWrapper = await deployer.wrapDeployedContract(Articles, '0x4110D47063510dE66F6EB522e4c310b1B9A04372');

	//const tx = await articlesWrapper.contract.addArticle("tit", "desc", "pic");
	//console.log(articlesWrapper.contract);
	const articles = await articlesWrapper.contract.getArticles();
	console.log(articles);

};

const deployShishaCoin = async (network, secret) => {

	//const deployer = await new etherlime.EtherlimeGanacheDeployer();
	const defaultConfigs = {
		gasPrice: 20000000000,
		gasLimit: 4700000
	}
	const deployer = await new etherlime.InfuraPrivateKeyDeployer(userSecret, infuraNetwork, apiKey, defaultConfigs);
	//const shishaCoinWrapper = await deployer.deploy(ShishaCoin);
	//console.log(shishaCoinWrapper.contractAddress);
	const shishaCoinWrapper = await deployer.wrapDeployedContract(ShishaCoin, '0xC68E40FB0Ac91A7BCe5Ada3940806694e10D1B6B');

	//const shishaTokenWrapper = await deployer.deploy(ShishaToken, {}, shishaCoinWrapper.contractAddress);
	//console.log(shishaTokenWrapper.contractAddress);
	const shishaTokenWrapper = await deployer.wrapDeployedContract(ShishaToken, '0xc18611de70CF4060DA03b67ce2cE19Ea89707d57');

	//const userAddress = deployer.wallet.address;
	const userAddress = '0x0cB1ba350bAa4A869c187284d07DD4C6670C56fd';//test user

	//const tx1 = await shishaCoinWrapper.contract.mint(shishaTokenWrapper.contractAddress, 100000); //promotional tokens
	const tx2 = await shishaCoinWrapper.contract.mint(userAddress, 100);
	await shishaCoinWrapper.verboseWaitForTransaction(tx2, "Minting 10 bill tokens");

	// for vote contract maybe
	const txx22 = await shishaCoinWrapper.contract.addMinter(shishaTokenWrapper.contractAddress);
	await shishaCoinWrapper.verboseWaitForTransaction(txx22, "add minter");

	const ownerBalance333 = await shishaCoinWrapper.contract.balanceOf(userAddress);
	console.log('b', ownerBalance333.toString());

	const ownerBalance444 = await shishaCoinWrapper.contract.balanceOf(shishaTokenWrapper.contractAddress);
	console.log('b', ownerBalance444.toString());

	const ownerBalance44422 = await shishaCoinWrapper.contract.balanceOf(shishaCoinWrapper.contractAddress);
	console.log('b', ownerBalance44422.toString());

	const ownerBalance4444 = await shishaCoinWrapper.contract.totalSupply();
	console.log('b', ownerBalance4444.toString());

	//const ownerBalancee = await shishaCoinWrapper.contract.claimBonus();
	//await shishaCoinWrapper.verboseWaitForTransaction(ownerBalancee, "wait claim bonus");
	
	const ownerBalance1333 = await shishaCoinWrapper.contract.balanceOf(deployer.wallet.address);
	console.log('b', ownerBalance1333.toString());


	// const ownerBalance1 = await shishaCoinWrapper.contract.balanceOf(shishaTokenWrapper.contractAddress);
	// console.log(ownerBalance1.toString());

	// // const tx3 = await shishaTokenWrapper.contract.buyShisha("58139243173161992395834150821221735921881255132701291781722221023820786814020");
	// // await shishaTokenWrapper.verboseWaitForTransaction(tx3, "Buying first shisha");

	const ownerBalance3 = await shishaTokenWrapper.contract.getAllShishaTokens(userAddress);
	console.log('s', ownerBalance3);

	const ownerBalance4 = await shishaTokenWrapper.contract.balanceOf(userAddress);
	console.log('s', ownerBalance4.toString());

	const ownerBalance2 = await shishaTokenWrapper.contract.getReceivedOffers(userAddress);
	console.log('0', ownerBalance2);

	const pffer = await shishaTokenWrapper.contract.getOffers("58139243173161992395834150821221735921881255132701291781722221023820786814020");
	console.log('0', pffer);
	//58139243173161992395834150821221735921881255132701291781722221023820786814020
};


const deployCrowdsale = async (network, secret) => {

	//const deployer = await new etherlime.EtherlimeGanacheDeployer();
	const defaultConfigs = {
		gasPrice: 20000000000,
		gasLimit: 4700000
	}
	const deployer = await new etherlime.InfuraPrivateKeyDeployer(userSecret, infuraNetwork, apiKey, defaultConfigs);
	//const shishaPremiumCoinWrapper = await deployer.deploy(ShishaPremiumCoin);
	//console.log(shishaPremiumCoinWrapper.contractAddress);
	const shishaPremiumCoinWrapper = await deployer.wrapDeployedContract(ShishaPremiumCoin, '0x0015Bf74fbd1af6E7fA210472D0bcA1F46f33d28');

	//const shishaCrowdsaleWrapper = await deployer.deploy(ShishaCrowdsale, {}, 10000000, 1000000, 1543587059023, 1543932498008, deployer.wallet.address, shishaPremiumCoinWrapper.contractAddress);
	//console.log(shishaCrowdsaleWrapper.contractAddress);
	const shishaCrowdsaleWrapper = await deployer.wrapDeployedContract(ShishaCrowdsale, '0xEEe9A9426159349CB57D6Ab57D23a59757603Fa6');

	const userAddress = deployer.wallet.address;
	//const userAddress = '0x0cB1ba350bAa4A869c187284d07DD4C6670C56fd';//test user
	const tx1 = await shishaPremiumCoinWrapper.contract.mint(shishaPremiumCoinWrapper.contractAddress, 100000); //promotional tokens
	const tx2 = await shishaPremiumCoinWrapper.contract.mint(shishaCrowdsaleWrapper.contractAddress, 100002); //promotional tokens
	

	const ownerBalance33312 = await shishaPremiumCoinWrapper.contract.totalSupply();
	console.log('b', ownerBalance33312.toString());

	const ownerBalance333 = await shishaPremiumCoinWrapper.contract.balanceOf(shishaCrowdsaleWrapper.contractAddress);
	console.log('b', ownerBalance333.toString());

	const ownerBalance444 = await shishaPremiumCoinWrapper.contract.balanceOf(userAddress);
	console.log('b', ownerBalance444.toString());

	const ownerBalance4441 = await shishaPremiumCoinWrapper.contract.balanceOf("0x513195812aaaF2428acF41aCE9CF92599c3db479");
	console.log('b', ownerBalance4441.toString());


	//const ownerBalancee = await shishaCrowdsaleWrapper.contract.buyTokens(deployer.wallet.address);
	//await shishaCoinWrapper.verboseWaitForTransaction(ownerBalancee, "wait claim bonus");
	

	// // const tx3 = await shishaTokenWrapper.contract.buyShisha("58139243173161992395834150821221735921881255132701291781722221023820786814020");
	// // await shishaTokenWrapper.verboseWaitForTransaction(tx3, "Buying first shisha");

	
};

module.exports = {
	deploy
};