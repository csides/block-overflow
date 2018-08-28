## Withdrawal
    As mentioned in design patters file, the Withdraw pattern was used in order to prevent double withdrawals or
    other issues with sending ether. This also helps the issue of needing to payout to a very long list of individuals. 
## Tx.Origin
    tx.origin was avoided in almost all cases, with only one exception in which the call needed to pass through a contract.
    This could be avoided with another argument being passed through the chain of contract calls, as to the original callers
    address.
## Malicious Admins
    This is a significant issue with the current structure of the contract. The admins and owner have significant control
    over the contract, questions, answers, and value. A feature that should be implemented to help mitigate this risk is to have
    admins vote on certain decisions, such as halting the contract, taking away a users funds, or other serious issues.
## Integer overflow
    Integer overflow was taken into account in this project. Not very much integer math was used, and where
    it was, overflow would only be caused by having an account with the max amount of ether (infeasible). Underflow
    was also deemed to not be a concern.
## Poisoned data
    Most function calls are limited in their scope, and they check their input where appropriate. In the majority of cases,
    poisned data results in an error being thrown and the transaction being reverted, without any negative impact on the 
    rest of the contract network.
## Denial of service
    This is potentially a problem given that the contract works with a lot of strings, and potentially very long lists
    of items. This has been mitigated by ensuring that the only time an entire list is accessed is from a 'view' context.
    Additionally, the question and answer fees are intended to force the attacker to store enough value in a given question,
    answer, or upvote that they would not be able to effectively carry out a denial of service attack without wasting an
    enormous amount of resources.
## Timestamp manipulation
    While the timestamp features of this application were not fully implemented, they were designed with miner manipulation in
    mind. The degree with which a miner is able to manipulate the timestamp at which the block found (usually 30 seconds, at max
    around 15 min), would not have significantly impacted the delays between answer acceptace / rejection, and the time at which
    their value could be collected (inteded to be 6+ hours up to 3 days).