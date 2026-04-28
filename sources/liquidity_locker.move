module create_token_workshop::liquidity_locker {
    use sui::dynamic_field as df;
    use sui::clock::{Self, Clock};

    /// Error codes
    const ELockNotExpired: u64 = 0;
    const ENotOwner: u64 = 1;
    // 24 * 3,600,000 = 86,400,000$

    public struct LockedPosition<T: key + store> has key {
        id: UID,
        position: T,
        unlock_timestamp: u64,
        original_owner: address,
    }

    /// The Founder calls this to lock their Cetus Position NFT
    entry fun lock_position<T: key + store>(
        position: T,
        unlock_timestamp: u64,
        ctx: &mut TxContext
    ) {
        let id = object::new(ctx);
        let sender = tx_context::sender(ctx);

        let locked_pos = LockedPosition {
            id,
            position,
            unlock_timestamp,
            original_owner: sender,
        };

        // Transfer the locked wrapper to a shared object or keep it owned
        // For a public guarantee, we usually make it a shared object
        transfer::share_object(locked_pos);
    }

    /// Only the original owner can withdraw, and only AFTER the time has passed
    entry fun withdraw_position<T: key + store>(
        locked_wrapper: &mut LockedPosition<T>,
        clock: &Clock,
        ctx: &TxContext
    ) {
        let sender = ctx.sender();
        let current_time = clock::timestamp_ms(clock);

        assert!(sender == locked_wrapper.original_owner, ENotOwner);
        assert!(current_time >= locked_wrapper.unlock_timestamp, ELockNotExpired);

        // This is a placeholder for the logic to extract the NFT
        // let LockedPosition {id: id, position: position, unlock_timestamp: _, original_owner: _} = locked_wrapper;
        // object::delete(id);
        let position: T = df::remove(&mut locked_wrapper.id, b"position");


        // trf nft to owner
        transfer::public_transfer(position, sender);
    }
}
