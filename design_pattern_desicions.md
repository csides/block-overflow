## Factory Pattern:
    The factory pattern was used several times:
        Topic -> Questions
            Questions -> Answers
    The creating factory was in charge of managing certain overhead data for the spawned contracts. This was done
    so that questions and answers could be rapidly created without making any given contract too 'heavy' (in terms of data),
    and that the creator would pay the creation fee. This also maintains quick visibility into any needed contract, and 
    effectively divides the concerns of various parties.
## Restricting Access:
    Access was restricted on most function calls in almost all places. Originally, there was even the process of enrolling
    a given user address before that address could do essentially anything. It was dialed back to having Owner and Admin level
    privledges on certain functions that control the contract network. In other places, the question or answer owner had special
    privledges to call certain functions that would change the question answer behaviour flow.
## Withdraw Pattern:
    The Withdraw patter was used, both from Answer into Question, and from Topic to a given user. This should prevent
    an attack from using the 'failed sends' approach, or the approach of spamming the function with requests in order
    to attempt to withdraw the same funds twice.
## Circuit Breaker:
    A basic circuit breaker design was implemented to control withdrawals from the Topic contract. It was also
    enabled on halting question creation, to prevent spamming the the topic with more and more questions in the case of a
    vulnerability being found. Question and Answer activities were allowed to continue as intended to not totally
    disrupt service of the entire platform, while still protecting the assets and entire network.
## Failing loud:
    There was a balance struck between using require() and if() _; statements.
    In some cases, the function simply did not want someone to have access or did not want to execute
    unless a condition was met, and thus failing silently was appropriate. In other cases, a loud failure was
    needed to alert the caller that the transaction had failed.
## Others:
    Mortal contract, auto deprecation, etc were not used.