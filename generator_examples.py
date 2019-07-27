#! /usr/bin/env python3

# because of differences in the generator object implementations between
# Python versions 2 and 3, this script requires Python 3

# generator_examples.py - examples using Python generators
# Copyright (C) 2019  Erik Auerswald <auerswal@unix-ag.uni-kl.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

heading = 'Playing with Python generators:'
print(heading, '\n' + '-' * len(heading) + '\n')

# using 'yield' inside a function creates a generator function
def g1():
    print('Generator g1 started')
    yield 0
    yield 1
    yield 2
    print('Generator g1 is empty')
print('⇒ g1 =', g1)

def g2(n):
    print('Generator g2 started')
    for i in range(n):
        yield i
    print('Generator g2 is empty')
print('⇒ g2 =', g2)

# generators can be used directly in a for loop
print('⇒ Using calls to generator functions in a for loop:')
for i in g1():
    print(i)
for i in g2(3):
    print(i)

# generators can be re-used in for loops
for i in g1():
    print(i)
for i in g2(3):
    print(i)

# generators return a generator instance
print('⇒ Using generator objects:')
gen1 = g1()
print('⇒ gen1 =', gen1)
gen2 = g2(3)
print('⇒ gen2 =', gen2)

# generator instances can be used in a for loop
print('⇒ Using generator objects in a for loop:')
for i in gen1:
    print(i)
for i in gen2:
    print(i)

# generator instances cannot be re-used
print('⇒ Using generator objects gen1 & gen2 a second time:')
for i in gen1:
    print(i)
for i in gen2:
    print(i)
print('⇒ After using gen1 & gen2 a second time')

# generator objects return themselves when asked for an iterator
gen3 = g1()
print('⇒ gen3 is gen3.__iter__() ==', gen3 is gen3.__iter__())
# generator objects can be iterated over calling .__next__()
# in Python 2, this method was called next()
print('⇒ Iteration over gen3 using gen3.__next__():')
gen3.__next__()
gen3.__next__()
gen3.__next__()
print('⇒ Calling .__next__() on an empty generator object raises an exception:')
try:
    gen3.__next__()
except StopIteration:
    print('⇒ Caught "StopIteration" exception')
print('⇒ gen3 is gen3.__iter__() ==', gen3 is gen3.__iter__())

# the built-in function next() can be used instead of calling the
gen4 = g1()
print('⇒ Iteration over gen4 using next(gen4):')
print(next(gen4))
print(next(gen4))
print(next(gen4))
print('⇒ Calling next() on an empty generator object raises an exception:')
try:
    print(next(gen4))
except StopIteration:
    print('⇒ Caught "StopIteration" exception')

# fibonacci sequence generator (starting with F₀=0)
print('⇒ Generating Fibonacci sequence:')
def gen_fib_seq():
    i, j = 0, 1
    while True:
        yield i
        i, j = j, i + j

fib = gen_fib_seq()
for i in range(41):
    print('Fibonacci number {:2d}:'.format(i), '{:9d}'.format(next(fib)))

obs = '''\
Observations:
-------------

  A generator function is a function using 'yield'. The function
  returns a generator object. The generator object can be used to
  generate a sequence of values once, but is not reset after completion,
  i.e., the generator object is an interator.

  A generator function can use its arguments to create parameterized
  generator objects. The initial state of the generator object (instance)
  can be based on the arguments to the generator function.

  Using a call to a generator function instead of a generator object in
  a for loop creates a new unnamed generator object, thus the generator
  function can be iterated over again and again. The generator function
  itself is not iterable, only its return value, the generator object, is.

  A generator function does not contain .__iter__ or .__next__ methods,
  but the generator object does. Using generator_function() in a
  for loop means calling the generator function, which returns a new
  generator object, which is then iterated over.

  A generator function can be ietrated over manually using either its
  .__next__() method or using the built-in function next().
  A generator object keeps local state over consecutive calls to its
  .__next__ method.

  In Python 2, the .__next__() method was called .next().
'''
print()
print(obs)

# vim:tabstop=4:shiftwidth=4:expandtab:
