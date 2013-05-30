import subprocess
import re
import time

def get_data():
  lines = subprocess.Popen(['ioreg',  '-lw0'], stdout=subprocess.PIPE).\
      communicate()[0]
  lines = lines.split('\n')
  for line in lines:
    m = re.match('.*\"PerformanceStatistics\".*', line)
    if m:
      def get_stat(name):
        m = re.match('(.*\"' + name + '\"=)' + '(?P<stat>\d*)' + '(.*)', line)
        result = {}
        if m:
          return int(m.group("stat"))
        else:
          raise Exception(name + ' not found in PerformanceStatistics')
      return {
          'vramUsedBytes': get_stat('vramUsedBytes'),
          'contextGLCount': get_stat('contextGLCount')}


  raise Exception('PerformanceStatistics not found')

baseline = get_data()
print 'Baseline VRAM usage: %d MB, %d contexts, %d bytes' % (
    baseline['vramUsedBytes']/1048576, baseline['contextGLCount'],  baseline['vramUsedBytes'])
while 1:
  data = get_data()
  print '  %d MB, %d contexts, %d bytes' % (
      (data['vramUsedBytes'] - baseline['vramUsedBytes'])/1048576,
      (data['contextGLCount'] - baseline['contextGLCount']),
      (data['vramUsedBytes'] - baseline['vramUsedBytes']))
  time.sleep(1)
