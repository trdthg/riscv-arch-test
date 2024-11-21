.PHONY: coverage ctg

coverage:
	cd riscof-plugins/rv64 \
	&& time riscof coverage --config=config.ini --suite=./riscv-arch-test/riscv-test-suite/ --env=./riscv-arch-test/riscv-test-suite/env \
		--no-browser \
		--cgf-file=./riscv-arch-test/coverage/dataset.cgf \
		--cgf-file=./riscv-arch-test/coverage/i/rv64i.cgf \
		--cgf-file=./riscv-arch-test/coverage/priv/rv64i_priv.cgf \
		--cgf-file=./riscv-arch-test/coverage/m/rv64im.cgf \
		--select-filter=/sraw

run:
	cd riscof-plugins/rv64 \
	&& time riscof run --config=config.ini --suite=./riscv-arch-test/riscv-test-suite/ --env=./riscv-arch-test/riscv-test-suite/env \
		--testfile=./riscv-arch-test/coverage/dataset.cgf \
		--testfile=./riscv-arch-test/coverage/i/rv64i.cgf

ctg:
	riscv_ctg -v debug -d ./tests/ -cf ./coverage/dataset.cgf -cf ./coverage/i/rv64i.cgf -bi rv64i

isac:
	cd /workspaces/riscv-arch-test/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sra-01.S \
	&& riscv64-unknown-elf-gcc -march=rv64i          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T /workspaces/riscv-arch-test/riscof-plugins/rv64/sail_cSim/env/link.ld         -I /workspaces/riscv-arch-test/riscof-plugins/rv64/sail_cSim/env/         -I /workspaces/riscv-arch-test/riscv-test-suite/env -mabi=lp64  /workspaces/riscv-arch-test/riscv-test-suite/rv64i_m/I/src/sra-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64  -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=/workspaces/riscv-arch-test/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sra-01.S/Reference-sail_c_simulator.signature ref.elf > sra-01.log 2>&1 \
	&& riscv_isac --verbose info coverage -d \
		-t sra-01.log --parser-name c_sail -o coverage.rpt \
		--sig-label begin_signature  end_signature \
		--test-label rvtest_code_begin rvtest_code_end \
		-e ref.elf -c /workspaces/riscv-arch-test/coverage/dataset.cgf \
		-c /workspaces/riscv-arch-test/coverage/i/rv64i.cgf \
		-c /workspaces/riscv-arch-test/coverage/priv/rv64i_priv.cgf \
		-c /workspaces/riscv-arch-test/coverage/m/rv64im.cgf -x64 \
		-l sra

ctg-sraw:
	riscv_ctg -v debug -d ./tests/ -cf ./coverage/dataset.cgf -cf ./coverage/i/rv64i.cgf -bi rv64i

dd:
	cd /workspaces/riscv-arch-test/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sraw-01.S \
	&& riscv64-unknown-elf-gcc -march=rv64i          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T /workspaces/riscv-arch-test/riscof-plugins/rv64/sail_cSim/env/link.ld         -I /workspaces/riscv-arch-test/riscof-plugins/rv64/sail_cSim/env/         -I /workspaces/riscv-arch-test/riscv-test-suite/env -mabi=lp64  /workspaces/riscv-arch-test/riscv-test-suite/rv64i_m/I/src/sraw-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64  -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=/workspaces/riscv-arch-test/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sraw-01.S/Reference-sail_c_simulator.signature ref.elf > sraw-01.log 2>&1 \
	&& riscv_isac --verbose info coverage -d                         -t sraw-01.log --parser-name c_sail -o coverage.rpt                          --sig-label begin_signature  end_signature                         --test-label rvtest_code_begin rvtest_code_end                         -e ref.elf -c /workspaces/riscv-arch-test/coverage/dataset.cgf -c /workspaces/riscv-arch-test/coverage/i/rv64i.cgf -c /workspaces/riscv-arch-test/coverage/priv/rv64i_priv.cgf -c /workspaces/riscv-arch-test/coverage/m/rv64im.cgf -x64   -l sraw    ;
