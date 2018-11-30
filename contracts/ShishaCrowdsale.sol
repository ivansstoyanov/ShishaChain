pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

//import "../node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../node_modules/openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "../node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";

contract ShishaCrowdsale is RefundableCrowdsale, CappedCrowdsale {

    using SafeMath for uint256;

    uint256 public startDate;

    //uint256 public constant CROWDSALE_DURATION = 7 days;
    uint256 public constant PUBLIC_SALES_1_PERIOD_END = 1 days;
    uint256 public constant PUBLIC_SALES_2_PERIOD_END = 2 days;

    uint256 public constant MIN_CONTRIBUTION_AMOUNT = 50 finney; // 0.05 ETH

    uint256 public constant REGULAR_RATE = 100;
    uint256 public constant PUBLIC_SALES_1_RATE = 130; // 30% bonus
    uint256 public constant PUBLIC_SALES_2_RATE = 115; // 15% bonus

    event LogBountyTokenDonation(address beneficiary, uint256 amount);

    constructor(uint _cap, uint _goal, uint _startDate, uint _endDate, address _wallet, address _token) public
        CappedCrowdsale(_cap)
        RefundableCrowdsale(_goal)
        TimedCrowdsale(_startDate, _endDate)
        Crowdsale(REGULAR_RATE, _wallet, IERC20(_token))
    {
        require(_goal <= _cap, "Goal is bigger than cap");
        //require(_endDate.sub(_startDate) == CROWDSALE_DURATION, "Crowdsale duration is not 7 weeks");

        startDate = _startDate;
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(weiAmount >= MIN_CONTRIBUTION_AMOUNT, "Your have to pay minimum of 50 finney to buy tokens");

        super._preValidatePurchase(beneficiary, weiAmount);
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        return weiAmount.mul(getRate());
    }

    function getRate() internal view returns(uint256) {
        
        if (now <= startDate.add(PUBLIC_SALES_1_PERIOD_END)) {
            return PUBLIC_SALES_1_RATE;
        }

        if (now <= startDate.add(PUBLIC_SALES_2_PERIOD_END)) {
            return PUBLIC_SALES_2_RATE;
        }

        return REGULAR_RATE;
    }
}