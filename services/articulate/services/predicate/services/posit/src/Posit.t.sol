// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Charge } from "./Charge.sol";

/// Exercises positing: the charge bilattice and its conflation with the
/// articulation corners generated one stage up.
contract PositTest {
    function testChargeConflationRoundTripsEveryCorner() public pure {
        for (uint8 corner = 0; corner < 4; corner++) {
            require(
                Charge.toArticulationCorner(Charge.fromArticulationCorner(corner)) == corner,
                "conflation round trip"
            );
        }
    }

    function testNegateReversesTruthAndPreservesKnowledge() public pure {
        require(
            Charge.toArticulationCorner(Charge.negate(Charge.tTop())) ==
                Charge.toArticulationCorner(Charge.tBot()),
            "negate swaps tTop and tBot"
        );
        require(
            Charge.toArticulationCorner(Charge.negate(Charge.kBot())) ==
                Charge.toArticulationCorner(Charge.kBot()),
            "negate fixes kBot"
        );
        require(Charge.leK(Charge.kBot(), Charge.kTop()), "kBot below kTop in knowledge");
        require(Charge.leT(Charge.tBot(), Charge.tTop()), "tBot below tTop in truth");
    }

    function testKnowledgeAndTruthJoinsDiffer() public pure {
        Charge.Corner memory a = Charge.tTop();
        Charge.Corner memory b = Charge.tBot();
        require(Charge.toArticulationCorner(Charge.joinK(a, b)) == 2, "joinK of tTop,tBot is kTop");
        require(Charge.toArticulationCorner(Charge.joinT(a, b)) == 1, "joinT of tTop,tBot is tTop");
        require(Charge.toArticulationCorner(Charge.meetK(a, b)) == 0, "meetK of tTop,tBot is kBot");
        require(Charge.toArticulationCorner(Charge.meetT(a, b)) == 3, "meetT of tTop,tBot is tBot");
    }
}
