from constraint import *

problem = Problem()

from riscv_ctg.constants import *

rs1_val_data = gen_sign_dataset(64) + gen_sp_dataset(64, True)

rs2_val_data = gen_usign_dataset(ceil(log(64, 2)))

problem.addVariable("rs1_val", rs1_val_data)

problem.addVariable("rs2_val", rs2_val_data)

xlen = 64

print(rs2_val_data)

problem.addConstraint(
    # lambda rs1_val, rs2_val: rs1_val < 0 and rs2_val == 0
    lambda rs1_val, rs2_val: rs1_val == (-(2 ** (xlen - 1)))
    and rs2_val >= 0
    and rs2_val < xlen,
    ("rs1_val", "rs2_val"),
)

res = problem.getSolutions()
print(res)
