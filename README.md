# v4-template
### **From saucepoint's v4-template 🦄**

## Scripts:

```
# to create the hook
forge script script/CreateHook.s.sol \
    --rpc-url https://polygon-mumbai.infura.io/v3/<auth> \
    --private-key <private key> \
    --code-size-limit 30000 \
    --broadcast

# to create the pool using this hook
forge script script/CreatePool.s.sol \
    --rpc-url https://polygon-mumbai.infura.io/v3/<auth> \
    --private-key <private key> \
    --code-size-limit 30000 \
    --broadcast

# to add liquidity to the pool(uses PoolModifyPositionTest contract instead of PoolManager)
forge script script/AddLiquidity.s.sol \
    --rpc-url https://polygon-mumbai.infura.io/v3/<auth> \
    --private-key <private key> \
    --code-size-limit 30000 \
    --broadcast
```
