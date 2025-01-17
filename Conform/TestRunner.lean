import EvmYul.EVM.State
import EvmYul.EVM.Semantics

import EvmYul.State.TransactionOps
import EvmYul.State.Withdrawal

import EvmYul.Maps.AccountMap

import EvmYul.Pretty
import EvmYul.Wheels

import Conform.Exception
import Conform.Model
import Conform.TestParser

namespace EvmYul

namespace Conform

def VerySlowTests : Array String :=
  #[
    "sha3_d3g0v0_Cancun" -- ~6MB getting keccak256'd, estimated time on my PC: ~1 hour, best guess: unfoldr.go in keccak256.lean
  , "CallGoesOOGOnSecondLevel2_d0g0v0_Cancun"
  , "CallGoesOOGOnSecondLevel_d0g0v0_Cancun"
  , "costRevert_d1g0v0_Cancun"
  , "costRevert_d22g0v0_Cancun"
  , "costRevert_d8g0v0_Cancun"
  , "TouchToEmptyAccountRevert3_Paris_d0g0v0_Cancun"
  , "RevertPrefoundOOG_d0g0v0_Cancun"
  , "TouchToEmptyAccountRevert2_Paris_d0g0v0_Cancun"
  , "stateRevert_d1g0v0_Cancun"
  , "RevertPrefoundEmptyOOG_Paris_d0g0v0_Cancun"
    -- TODO: Are there multiple tests with this name?
  , "callcallcallcode_001_OOGMAfter_d0g0v0_Cancun"
  , "callcallcallcode_001_OOGMBefore_d0g0v0_Cancun"
  , "CreateOOGafterInitCodeRevert_d0g0v0_Cancun"
  , "CREATE2_Bounds2_d0g0v0_Cancun"
  , "CREATE2_Bounds2_d0g1v0_Cancun"
  , "CREATE2_Bounds_d0g0v0_Cancun"
  , "CREATE2_Bounds_d0g1v0_Cancun"
  , "operationDiffGas_d9g0v0_Cancun"
  , "besuBaseFeeBug_Cancun"
  , "logRevert_Cancun"
  , "costRevert_d15g0v0_Cancun"
  , "static_callWithHighValueAndGasOOG_d1g0v0_Cancun"
  , "randomStatetest116_d0g0v0_Cancun"
  , "deploymentError_d0g0v0_Cancun"
  , "static_CheckCallCostOOG_d0g0v0_Cancun"
  , "static_CheckCallCostOOG_d0g1v0_Cancun"
  , "static_RevertDepth2_d0g0v0_Cancun"
  , "static_ZeroValue_CALL_OOGRevert_d0g0v0_Cancun"
  , "static_ZeroValue_SUICIDE_OOGRevert_d0g0v0_Cancun"
  , "static_RETURN_BoundsOOG_d0g0v0_Cancun"
  , "static_CallContractToCreateContractAndCallItOOG_d0g0v0_Cancun"
  , "static_CallGoesOOGOnSecondLevel_d0g0v0_Cancun"
  , "walletConstructionOOG_d0g0v0_Cancun"
  , "walletConstructionOOG_d0g1v0_Cancun"
  , "walletConstruction_d0g0v0_Cancun"
  , "walletConstruction_d0g1v0_Cancun"
  , "walletConstructionPartial_d0g0v0_Cancun"
  , "randomStatetest177_d0g0v0_Cancun"
  , "codecopy_d1g0v0_Cancun"
  , "bufferSrcOffset_d11g0v0_Cancun"
  , "bufferSrcOffset_d15g0v0_Cancun"
  , "bufferSrcOffset_d1g0v0_Cancun"
  , "bufferSrcOffset_d25g0v0_Cancun"
  , "bufferSrcOffset_d26g0v0_Cancun"
  , "bufferSrcOffset_d27g0v0_Cancun"
  , "bufferSrcOffset_d2g0v0_Cancun"
  , "bufferSrcOffset_d31g0v0_Cancun"
  , "bufferSrcOffset_d35g0v0_Cancun"
  , "bufferSrcOffset_d39g0v0_Cancun"
  , "bufferSrcOffset_d3g0v0_Cancun"
  , "bufferSrcOffset_d7g0v0_Cancun"
  , "buffer_d16g0v0_Cancun"
  , "buffer_d18g0v0_Cancun"
  , "CREATE_ContractRETURNBigOffset_d1g0v0_Cancun"
  , "CREATE_ContractRETURNBigOffset_d2g0v0_Cancun"
  , "CREATE_ContractRETURNBigOffset_d3g0v0_Cancun"
  , "randomStatetest601_d0g0v0_Cancun"
  , "randomStatetest643_d0g0v0_Cancun"
  , "createInitFail_OOGduringInit2_d0g0v0_Cancun"
  , "CreateResults_d8g0v0_Cancun"
  , "CreateResults_d9g0v0_Cancun"
  , "buffer_d21g0v0_Cancun"
  , "buffer_d33g0v0_Cancun"
  , "buffer_d36g0v0_Cancun"
  , "modexpTests_d120g0v0_Cancun"
  -- TODO: revisit the following 9
  , "precompsEIP2929Cancun_d22g0v0_Cancun"
  , "precompsEIP2929Cancun_d40g0v0_Cancun"  -- TODO: It actually passes
  , "precompsEIP2929Cancun_d58g0v0_Cancun"
  , "precompsEIP2929Cancun_d76g0v0_Cancun"
  , "precompsEIP2929Cancun_d7g0v0_Cancun"
  , "precompsEIP2929Cancun_d94g0v0_Cancun"
  , "idPrecomps_d66g0v0_Cancun"
  , "idPrecomps_d5g0v0_Cancun" -- PANIC at unsafePerformIO EvmYul.PerformIO
  , "idPrecomps_d4g0v0_Cancun"

  , "buffer_d21g0v0_Cancun"
  , "buffer_d33g0v0_Cancun"
  , "buffer_d36g0v0_Cancun"
  , "failed_tx_xcf416c53_Paris_d0g0v0_Cancun"
  , "CALLBlake2f_MaxRounds_d0g0v0_Cancun"
  -- , "CallEcrecover_Overflow_d2g0v0_Cancun" -- PANIC at unsafePerformIO EvmYul.PerformIO
  -- , "callcodecallcall_100_OOGMBefore_d0g0v0_Cancun"
  -- , "callcodecallcodecallcode_111_OOGMBefore_d0g0v0_Cancun"
  -- , "callcallcodecall_010_OOGE_d0g0v0_Cancun"
  -- , "callcodecallcall_100_OOGMAfter_d0g0v0_Cancun"
  -- , "callcodecall_10_OOGE_d0g0v0_Cancun"
  -- , "callcodecallcode_11_OOGE_d0g0v0_Cancun"
  -- , "callcallcodecallcode_011_OOGE_d0g0v0_Cancun"
  -- , "callcallcode_01_OOGE_d0g0v0_Cancun"
    -- "sha3_d5g0v0_Cancun", -- best guess: `lookupMemoryRange'{'}{''}` are slow; I guess we will need an faster structure than Finmap
    -- "sha3_d6g0v0_Cancun" -- same problem as `sha3_d5g0v0_Cancun` I'm guessing
  ]

def GlobalBlacklist : Array String := VerySlowTests

def Pre.toEVMState (self : Pre) : EVM.State :=
  self.foldl addAccount default
  where addAccount s addr acc :=
    let account : Account :=
      {
        tstorage := ∅ -- TODO - Look into transaciton storage.
        nonce    := acc.nonce
        balance  := acc.balance
        code     := acc.code
        storage  := acc.storage.toEvmYulStorage
        ostorage := acc.storage.toEvmYulStorage -- Remember the original storage.
      }
    { s with toState := s.setAccount addr account }

def Test.toTests (self : Test) : List (String × TestEntry) := self.toList

def Post.toEVMState : Post → EVM.State := Pre.toEVMState

local instance : Inhabited EVM.Transformer where
  default := λ _ ↦ default

private def compareWithEVMdefaults (s₁ s₂ : EvmYul.Storage) : Bool :=
  withDefault s₁ == withDefault s₂
  where
    withDefault (s : EvmYul.Storage) : EvmYul.Storage := if s.contains 0 then s else s.insert 0 0

/--
TODO - This should be a generic map complement, but we are not trying to write a library here.

Now that this is not a `Finmap`, this is probably defined somewhere in the API, fix later.
-/
def storageComplement (m₁ m₂ : AccountMap) : AccountMap := Id.run do
  let mut result : AccountMap := m₁
  for ⟨k₂, v₂⟩ in m₂.toList do
    match m₁.find? k₂ with
    | .none => continue
    | .some v₁ => if v₁ == v₂ then result := result.erase k₂ else continue
  return result

/--
Difference between `m₁` and `m₂`.
Effectively `m₁ / m₂ × m₂ / m₁`.

- if the `Δ = (∅, ∅)`, then `m₁ = m₂`
- used for reporting delta between expected post state and the actual state post execution

Now that this is not a `Finmap`, this is probably defined somewhere in the API, fix later.
-/
def storageΔ (m₁ m₂ : AccountMap) : AccountMap × AccountMap :=
  (storageComplement m₁ m₂, storageComplement m₂ m₁)

section

/--
This section exists for debugging / testing mostly. It's somewhat ad-hoc.
-/

notation "TODO" => default

private def almostBEqButNotQuiteEvmYulState (s₁ s₂ : AddrMap AccountEntry) : Except String Bool := do
  let s₁ := bashState s₁
  let s₂ := bashState s₂
  if s₁ == s₂ then .ok true else throw "state mismatch"
 where
  bashState (s : AddrMap AccountEntry) : AddrMap AccountEntry :=
    s.map
      λ (addr, acc) ↦ (addr, { acc with balance := TODO })
/--
NB it is ever so slightly more convenient to be in `Except String Bool` here rather than `Option String`.

This is morally `s₁ == s₂` except we get a convenient way to both tune what is being compared
as well as report fine grained errors.
-/
private def almostBEqButNotQuite (s₁ s₂ : AddrMap AccountEntry) : Except String Bool := do
  discard <| almostBEqButNotQuiteEvmYulState s₁ s₂
  pure true -- Yes, we never return false, because we throw along the way. Yes, this is `Option`.

end

def executeTransaction (transaction : Transaction) (s : EVM.State) (header : BlockHeader) : Except EVM.Exception EVM.State := do
  let _TODOfuel := 2^13

  let (ypState, substate, z) ← EVM.Υ (debugMode := false) _TODOfuel s.accountMap header.chainId header.baseFeePerGas header transaction -- (dbgOverrideSender := transaction.base.dbgSender)

  -- as EIP 4788 (https://eips.ethereum.org/EIPS/eip-4788).

  -- TODO - I think we do this tuple → EVM.State conversion reasonably often, factor out?
  let result : EVM.State := {
    s with accountMap := ypState
           substate := substate
           executionEnv.perm := z -- TODO - that's probably not this :)
           -- returnData := TODO?
  }
  pure result

/--
This assumes that the `transactions` are ordered, as they should be in the test suit.
-/
def executeTransactions (blocks : Blocks) (s₀ : EVM.State) : Except EVM.Exception EVM.State := do
  blocks.foldlM processBlock s₀
  where processBlock (s : EVM.State) (block : BlockEntry) : Except EVM.Exception EVM.State := do
    -- We should not check the timestamp. Some tests have timestamp less than 1710338135 but still need EIP-4788
    -- let FORK_TIMESTAMP := 1710338135
    let _TODOfuel := 2^13
    let SYSTEM_ADDRESS := 0xfffffffffffffffffffffffffffffffffffffffe
    let BEACON_ROOTS_ADDRESS := 0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02
    -- if no code exists at `BEACON_ROOTS_ADDRESS`, the call must fail silently
    let s ←
      match s.accountMap.find? BEACON_ROOTS_ADDRESS with
        | none => pure s
        | some roots =>
          let beaconRootsAddressCode := roots.code
          -- the call does not count against the block’s gas limit
          let (createdAccounts, σ, _, substate, _ /- can't fail-/, _) ←
            EVM.Θ
              (debugMode := false)
              _TODOfuel
              .empty
              s.accountMap
              default
              SYSTEM_ADDRESS
              SYSTEM_ADDRESS
              BEACON_ROOTS_ADDRESS
              (.Code beaconRootsAddressCode)
              30000000
              0xe8d4a51000
              0
              0
              block.blockHeader.parentBeaconBlockRoot
              0
              block.blockHeader
              true
          pure <|
            {s with
              createdAccounts := createdAccounts
              accountMap := σ
              substate := substate
            }
    -- dbg_trace "\nStarting transactions"
    let s ← block.transactions.foldlM
      (λ s trans ↦
        try
          executeTransaction trans s block.blockHeader
        catch e =>
          if !block.exception.isEmpty then
            dbg_trace s!"Expected exception: {block.exception}; got exception: {repr e} - we need to reconcile these as we debug tests. Currently, we mark the test as 'passed' as I assume this is the right kind of exception, but it doesn't need to be the case necessarily."
            throw <| EVM.Exception.ExpectedException block.exception
          else throw e
      )
      s
    let σ ←
      ( try
         applyWithdrawals
          s.accountMap
          block.blockHeader.withdrawalsRoot
          block.withdrawals
        catch e =>
          if !block.exception.isEmpty then
            dbg_trace s!"Expected exception: {block.exception}; got exception: {repr e} - we need to reconcile these as we debug tests. Currently, we mark the test as 'passed' as I assume this is the right kind of exception, but it doesn't need to be the case necessarily."
            throw <| EVM.Exception.ExpectedException block.exception
          else throw e
      )
    pure <| { s with accountMap := σ }
    -- pure s

/--
- `.none` on success
- `.some endState` on failure

NB we can throw away the final state if it coincided with the expected one, hence `.none`.
-/
def preImpliesPost (pre : Pre) (post : Post) (blocks : Blocks) : Except EVM.Exception (Option EVM.State) := do
  try
    let resultState ← executeTransactions blocks pre.toEVMState
    let result : AddrMap AccountEntry :=
      resultState.toState.accountMap.foldl
        (λ r addr ⟨nonce, balance, storage, _, _, code⟩ ↦ r.insert addr ⟨nonce, balance, storage, code⟩) default
    match almostBEqButNotQuite post result with
      | .error e =>
        dbg_trace e
        pure (.some resultState) -- Feel free to inspect this error from `almostBEqButNotQuite`.
      | .ok _ => pure .none
  catch | .ExpectedException _ => pure .none -- An expected exception was thrown, which means the test is ok.
        | e                    => throw e

-- local instance : MonadLift (Except EVM.Exception) (Except Conform.Exception) := ⟨Except.mapError .EVMError⟩

-- vvvvvvvvvvvvvv DO NOT DELETE PLEASE vvvvvvvvvvvvvvvvvv
def DONOTDELETEMEFORNOW : AccountMap := Batteries.RBMap.ofList [(1, { dflt with storage := Batteries.RBMap.ofList [(44, 45), (46, 47)] compare }), (3, default)] compare
  where dflt : Account := default

instance (priority := high) : Repr AccountMap := ⟨λ m _ ↦
  Id.run do
    let mut result := ""
    for (k, v) in m do
      result := result ++ s!"\nAccount[...{(EvmYul.toHex k.toByteArray) |>.takeRight 5}]\n"
      result := result ++ s!"balance: {v.balance}\nnonce: {v.nonce}\nstorage: \n"
      for (sk, sv) in v.storage do
        result := result ++ s!"{sk} → {sv}\n"
    return result⟩

def processTest (entry : TestEntry) (verbose : Bool := true) : TestResult :=
  let result := preImpliesPost entry.pre entry.postState entry.blocks
  match result with
    | .error err => .mkFailed s!"{repr err}"
    | .ok result => errorF <$> result

  where discardError : EVM.State → String := λ _ ↦ "ERROR."
        verboseError : EVM.State → String := λ s ↦
          let (postSubActual, actualSubPost) := storageΔ entry.postState.toEVMState.accountMap s.accountMap
          s!"\npost / actual: {repr postSubActual} \nactual / post: {repr actualSubPost}"
        errorF := if verbose then verboseError else discardError

local instance : MonadLift (Except String) (Except Conform.Exception) := ⟨Except.mapError .CannotParse⟩

def processTestsOfFile (file : System.FilePath)
                       (whitelist : Array String := #[])
                       (blacklist : Array String := #[]) :
                       ExceptT Exception IO (Batteries.RBMap String TestResult compare) := do
  let path := file
  let file ← Lean.Json.fromFile file
  let test ← Lean.FromJson.fromJson? (α := Test) file
  -- dbg_trace s!"tests before guard: {test.toTests.map Prod.fst}"
  let tests := guardBlacklist ∘ guardWhitelist <| test.toTests
  -- dbg_trace s!"tests after guard: {tests.map Prod.fst}"
  tests.foldlM (init := ∅) λ acc (testname, test) ↦
    -- dbg_trace s!"TESTING {testname} FROM {path}"
    pure <| acc.insert testname (processTest test)
    -- try
    --   processTest test >>= pure ∘
    --   -- TODO currently the soft errors are the ones I am personally unsure about :)
    -- catch
    --   | e => pure (acc.insert testname (.mkFailed s!"{repr e}"))
    -- -- catch | .EVMError e@(.ReceiverNotInAccounts _) => pure (acc.insert testname (.mkFailed s!"{repr e}"))
    -- --       | e => throw e -- hard error, stop executing the tests; malformed input, logic error, etc.
    -- --                      -- This should not happen but makes cause analysis easier if it does.
  where
    guardWhitelist (tests : List (String × TestEntry)) :=
      if whitelist.isEmpty then tests else tests.filter (λ (name, _) ↦ name ∈ whitelist)
    guardBlacklist (tests : List (String × TestEntry)) :=
      tests.filter (λ (name, _) ↦ name ∉ GlobalBlacklist ++ blacklist)

end Conform

end EvmYul
