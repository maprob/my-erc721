from brownie import accounts, config, MyERC721

def main():
    acc = accounts.add(config["wallets"]["from_key"])
    erc721 = MyERC721.deploy(
        {"from": acc}, publish_source=True
    )
    return erc721