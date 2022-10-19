if __name__ == '__main__':
    print("$@RUNE_START@$")
    print("$@RUNE_FILE(error)@$")
    a = 8
    if a == 9:
        print("This is equal to a")
    else:
        print("$@RUNE_ERROR(This is equal to the wrong value)@$")
    print("$@RUNE_END@$")
