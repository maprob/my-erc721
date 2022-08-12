from brownie import accounts, config, MyERC721

def main():
    acc = accounts.add(config["wallets"]["from_key"])
    baseUri = ""
    erc721 = MyERC721.deploy(
        baseUri, {"from": acc}, publish_source=True
    )
    return erc721