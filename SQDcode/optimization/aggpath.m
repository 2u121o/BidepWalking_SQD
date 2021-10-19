%%add path in order to use yalmip to write the optimization problem 
function aggpath()
    addpath([pwd '/yalmip']);
    addpath([pwd '/yalmip/extras']);
    addpath([pwd '/yalmip/solvers']);
    addpath([pwd '/yalmip/modules']);
    addpath([pwd '/yalmip/modules/parametric']);
    addpath([pwd '/yalmip/modules/moment']);
    addpath([pwd '/yalmip/modules/global']);
    addpath([pwd '/yalmip/modules/sos']);
    addpath([pwd '/yalmip/operators']);
end