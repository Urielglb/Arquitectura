from time import time


def count_elapsed_time(f):
    def wrapper(n):
        # Start counting.
        start_time = time()
        # Take the original function's return value.
        ret = f(n)
        # Calculate the elapsed time.
        elapsed_time = time() - start_time
        print("Elapsed time: %0.10f seconds." % elapsed_time)
        return ret
    
    return wrapper


n1, n2 = 0, 1
count = 0

@count_elapsed_time
def fibo(n):
    global n1,n2,count
    if nterms <= 0:
        print("Please enter a positive integer")
    elif nterms == 1:
        print("Fibonacci sequence upto",nterms,":")
        print(n1)
    else:
        print("Fibonacci sequence:")
    while count < nterms:
            print(n1)
            nth = n1 + n2
            n1 = n2
            n2 = nth
            count += 1

nterms = int(input("How many terms? "))
fibo(nterms)