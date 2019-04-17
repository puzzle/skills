module PerformanceHelpers
  # returns memory usage in kilobytes
  def get_memory_usage_kb
    GC.start
    `ps -o rss= -p #{Process.pid}`.to_i
  end
end
