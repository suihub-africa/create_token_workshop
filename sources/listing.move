module create_token_workshop::listing {
    use std::string::{Self};
    use sui::clock::Clock;
    use sui::coin::{Coin};

    use cetus_clmm::pool_creator::create_pool_v3;
    use create_token_workshop::create_token_workshop::CREATE_TOKEN_WORKSHOP;
    use cetus_clmm::config::GlobalConfig;
    use cetus_clmm::factory::Pools;
    use cetus_clmm::position::Position;


    entry fun list_coin<CoinB>(
        config: &GlobalConfig,
        pools: &mut Pools,
        coin_a: Coin<CREATE_TOKEN_WORKSHOP>,
        coin_b: Coin<CoinB>,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        // 1. Define Price (Using the 1:1 SqrtPrice we calculated)
        let sqrt_price_x64: u128 = 583313028212173400000;

        let tick_lower: u32 = 443640;
        let tick_upper: u32 = 443640;


        let (position, coin_a, coin_b) = create_pool_v3<CREATE_TOKEN_WORKSHOP, CoinB>(
            config,
            pools,
            60,
            sqrt_price_x64,
            b"https://res.cloudinary.com/georgegoldman/image/upload/v1775824438/github_profile_compressed_tstbqw.jpg".to_string(),
            4294523656, // This is how you represent -443640 in u32 (two's complement)
            443640,
            coin_a,
            coin_b,
            true, // fix_amount_a
            clock,
            ctx
        );

        transfer::public_transfer(position, ctx.sender());
        transfer::public_transfer(coin_a, ctx.sender());
        transfer::public_transfer(coin_b, ctx.sender());
    }
}
