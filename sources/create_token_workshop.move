
/// Module: create_token_workshop
module create_token_workshop::create_token_workshop;


// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

use sui::coin::create_currency;
use sui::coin::TreasuryCap;
use sui::coin::mint;
use sui::coin::Coin;
use sui::url::new_unsafe;
use std::option::some;

const DECIMALS: u8 = 6;
const NAME: vector<u8> = b"Goldman";
const SYMBOL: vector<u8> = b"Au";
const DESCRIPTION: vector<u8> = b"playing around with tokens";
const ICON_URL: vector<u8> = b"https://res.cloudinary.com/georgegoldman/image/upload/v1775824438/github_profile_compressed_tstbqw.jpg";

public struct CREATE_TOKEN_WORKSHOP  has drop{
}

fun init(otw: CREATE_TOKEN_WORKSHOP, ctx: &mut TxContext){

    let (mut treasury_cap, coin_metadata) = create_currency<CREATE_TOKEN_WORKSHOP>(otw, DECIMALS, SYMBOL, NAME, DESCRIPTION, some(new_unsafe(ICON_URL.to_ascii_string())), ctx);
    let amount = 10_000_000_000;
    let goldman_coin = mint_goldman(&mut treasury_cap, amount, ctx);

    transfer::public_transfer(treasury_cap, ctx.sender());
    transfer::public_transfer(goldman_coin, ctx.sender());
    transfer::public_freeze_object(coin_metadata);
}

fun mint_goldman(treasure_cap: &mut TreasuryCap<CREATE_TOKEN_WORKSHOP>, amount: u64, ctx: &mut TxContext): Coin<CREATE_TOKEN_WORKSHOP>
{
    mint<CREATE_TOKEN_WORKSHOP>(treasure_cap, amount, ctx)
}
