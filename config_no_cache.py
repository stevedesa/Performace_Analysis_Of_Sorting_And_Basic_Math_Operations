### This is the non-cached config file ###

import m5
from m5.objects import *

# Basic system setup
system = System()
system.clk_domain = SrcClockDomain()
system.clk_domain.clock = '1GHz'
system.clk_domain.voltage_domain = VoltageDomain()

# Memory range and mode
system.mem_mode = 'timing'
system.mem_ranges = [AddrRange('8GB')]

# ARM CPU setup (Uncomment required setup)
system.cpu = ArmTimingSimpleCPU()
# system.cpu = ArmO3CPU()
# system.cpu = ArmMinorCPU()

# Memory bus
system.membus = SystemXBar()

# Connect CPU instruction and data cache ports to the memory bus
system.cpu.icache_port = system.membus.cpu_side_ports
system.cpu.dcache_port = system.membus.cpu_side_ports
system.cpu.createInterruptController()
system.system_port = system.membus.cpu_side_ports

# Memory controller and DRAM configuration
system.mem_ctrl = MemCtrl()
system.mem_ctrl.dram = DDR3_1600_8x8() 
system.mem_ctrl.dram.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.mem_side_ports

# Setting up a process to run code
process = Process()

# Set up to run QSort (Uncomment required setup)
binary1 = 'benchmarks/qsort/qsort1'
binary2 = 'benchmarks/qsort/qsort2'
binary3 = 'benchmarks/qsort/qsort3'
inputsmall = 'benchmarks/qsort/input_small.dat'
inputlarge = 'benchmarks/qsort/input_large.dat'

# system.workload = SEWorkload.init_compatible(binary3)
# process.cmd = [binary3, inputlarge]

# Set up to run BasicMath
binaryexe = 'benchmarks/basicmath/basicmath_small'

system.workload = SEWorkload.init_compatible(binaryexe)
process.cmd = [binaryexe]

system.cpu.workload = process
system.cpu.createThreads()

# Root and instantiation
root = Root(full_system=False, system=system)
m5.instantiate()

print("Starting simulation")
exit_event = m5.simulate()
end_tick = m5.curTick()
print(f"Exiting @ tick {end_tick} because {exit_event.getCause()}")