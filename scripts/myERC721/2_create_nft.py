from brownie import MyERC721, accounts, config
from scripts.helpful_scripts import listen_for_event
import time

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    advanced_collectible = MyERC721[len(MyERC721) - 1]
    transaction = advanced_collectible.create({"from": dev})
    print("Waiting on second transaction...")
    transaction.wait(1)
    listen_for_event(
        advanced_collectible, "CreatedNFT", timeout=200, poll_interval=10
    )
    tokenId = transaction.events["CreatedNFT"]["tokenId"]
    # token_id = advanced_collectible.requestIdToTokenId(tokenId)
    # print("Dog breed of tokenId {} is {}".format(token_id, breed))