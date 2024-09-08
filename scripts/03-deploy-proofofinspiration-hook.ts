/* eslint-disable no-console */
import {ethers} from 'hardhat'

async function main() {
    const [deployer] = await ethers.getSigners()
    console.log('Deploying contracts with the account:', deployer.address)

    const ProofOfInspirationHook = await ethers.getContractFactory(
        'ProofOfInspirationHook'
    )

    // Hardcoded gas price in gwei
    const gasPriceGwei = 1.5
    const gasPrice = ethers.parseUnits(gasPriceGwei.toString(), 'gwei')

    console.log('Using gas price:', gasPriceGwei, 'gwei')

    console.log('Deploying ProofOfInspirationHook...')
    const proofOfInspirationHook = await ProofOfInspirationHook.deploy(
        '0x036CbD53842c5426634e7929541eC2318f3dCF7e',
        {gasPrice}
    )

    await proofOfInspirationHook.waitForDeployment()
    console.log(
        'ProofOfInspirationHook deployed to:',
        await proofOfInspirationHook.getAddress()
    )
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
