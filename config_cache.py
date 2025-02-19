### This is the cached config file ###

import m5
from m5.objects import *

# Define L1 Cache
class L1Cache(Cache):
  assoc = 2
  tag_latency = 2
  data_latency = 2
  response_latency = 2
  mshrs = 4
  tgts_per_mshr = 20

  def connectCPU(self, cpu):
    raise NotImplementedError

  def connectBus(self, bus):
    self.mem_side = bus.cpu_side_ports

# Instruction and Data L1 Cache subclasses
class L1ICache(L1Cache):
  size = '16kB'

  def connectCPU(self, cpu):
    self.cpu_side = cpu.icache_port


class L1DCache(L1Cache):
  size = '64kB'

  def connectCPU(self, cpu):
    self.cpu_side = cpu.dcache_port

# Define L2 Cache
class L2Cache(Cache):
  size = '256kB'
  assoc = 8
  tag_latency = 20
  data_latency = 20
  response_latency = 20
  mshrs = 20
  tgts_per_mshr = 12

  def connectCPUSideBus(self, bus):
    self.cpu_side = bus.mem_side_ports

  def connectMemSideBus(self, bus):
    self.mem_side = bus.cpu_side_ports

# Basic system setup
system = System()
system.clk_domain = SrcClockDomain()
system.clk_domain.clock = '1GHz'
system.clk_domain.voltage_domain = VoltageDomain()

# Memory range and mode
system.mem_mode = 'timing'
system.mem_ranges = [AddrRange('8GB')]

# CPU setup (Uncomment required setup)
system.cpu = ArmTimingSimpleCPU()
# system.cpu = ArmO3CPU()
# system.cpu = ArmMinorCPU()

# L1 and L2 Cache setup
system.cpu.icache = L1ICache()
system.cpu.dcache = L1DCache()
system.l2cache = L2Cache()

# Connect CPU caches to ports
system.cpu.icache.connectCPU(system.cpu)
system.cpu.dcache.connectCPU(system.cpu)

# Setup interconnects
system.l2bus = L2XBar()
system.cpu.icache.connectBus(system.l2bus)
system.cpu.dcache.connectBus(system.l2bus)
system.l2cache.connectCPUSideBus(system.l2bus)

# Memory bus
system.membus = SystemXBar()
system.system_port = system.membus.cpu_side_ports
system.l2cache.connectMemSideBus(system.membus)

# Set up the interrupt controller for the ARM CPU
system.cpu.createInterruptController()

# Memory controller setup
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