module create_token_workshop::listing {
    // use std::string::{Self};
    use sui::clock::Clock;
    use sui::coin::{Coin};

    use cetus_clmm::pool_creator::create_pool_v3;
    use create_token_workshop::create_token_workshop::CREATE_TOKEN_WORKSHOP;
    use cetus_clmm::config::GlobalConfig;
    use cetus_clmm::factory::Pools;
    // use cetus_clmm::position::Position;


    entry fun list_coin<CoinB>(
        config: &GlobalConfig,
        pools: &mut Pools,
        coin_a: Coin<CREATE_TOKEN_WORKSHOP>,
        coin_b: Coin<CoinB>,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        // 1. Define Price (Using the 1:1 SqrtPrice)
        let sqrt_price_x64: u128 = 583313028212173400000;

        // 2. Corrected Ticks for 60 Spacing
        // Lower Tick: -443580 (Closest multiple of 60 to the -443636 limit)
        let tick_lower: u32 = 4294523716;

        // Upper Tick: +443580 (Closest multiple of 60 to the +443636 limit)
        let tick_upper: u32 = 443580;


        let (position, leftof_coin_a, leftof_coin_b) = create_pool_v3<CoinB, CREATE_TOKEN_WORKSHOP>(
            config,
            pools,
            60,
            sqrt_price_x64,
            b"https://res.cloudinary.com/georgegoldman/image/upload/v1775824438/github_profile_compressed_tstbqw.jpg".to_string(),
            tick_lower, // This is how you represent -443640 in u32 (two's complement)
            tick_upper,
            coin_b,
            coin_a,
            true, // fix_amount_a
            clock,
            ctx
        );

        transfer::public_transfer(position, ctx.sender());
        transfer::public_transfer(leftof_coin_a, ctx.sender());
        transfer::public_transfer(leftof_coin_b, ctx.sender());
    }
}
