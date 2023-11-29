#!/usr/bin/python3

try:
    import os
    import sys
    from rapidfuzz import fuzz
    from concurrent.futures import ProcessPoolExecutor
except:
    print("Unable to load libriaries: os, sys, rapidfuzz, concurent\n\
    Try:\n\
    pip install rapidfuzz concurrent")

class Cmp_fuzz:
    def __init__(self, file_list1: list, file_list2: list):
        self.file_list1 = file_list1
        self.file_list2 = file_list2

    def compare_files(self, file1, file2):
        try:
            content1 = open(file1, 'r').read()
            content2 = open(file2, 'r').read()
        except:
            print("unable to read files: %s %s\n"%(file1, file2))
            return -1
        dist = fuzz.ratio(content1, content2)
        return dist

    def compare_files_parallel(self, file_pair):
        file1, file2 = file_pair
        return self.compare_files(file1, file2)

    def find_duplicates(self):
        duplicates = {}
        n = len(self.file_list1)
        m = len(self.file_list2)
        file_pairs = [(self.file_list1[i], self.file_list2[j]) for i in range(n) for j in range(m)]

        with ProcessPoolExecutor(max_workers=4) as executor:
            similarities = list(executor.map(self.compare_files_parallel, file_pairs))

        for i in range(len(file_pairs)):
            dist = similarities[i]
            if dist > 85:  # similarity in perc
                file1, file2 = file_pairs[i]
                if file1 in self.file_list1 and file1 not in duplicates:
                    duplicates[file1] = []
                if file2 in self.file_list2:
                    duplicates[file1].append(file2)
                if dist == 100: break

        return duplicates

    def find_uniques(self):
        uniques1 = [file for file in self.file_list1 if file not in self.duplicates]
        uniques2 = [file for file in self.file_list2 if file not in self.duplicates.values()]

        return uniques1, uniques2

    def run(self):
        self.duplicates = self.find_duplicates()
        uniques1, uniques2 = self.find_uniques()

        print("uniq1:")
        for file in uniques1:
            print(file)

        print("\nuniq2:")
        for file in uniques2:
            print(file)

        print("\ndupl:")
        for file, duplicates_list in self.duplicates.items():
            print(file)
            for duplicate in duplicates_list:
                print(f"  - {duplicate}")


def usage():
    print("%s"%(" ".join(sys.argv)))
    print("Usage:\
        %s file_list1 file_list2\
        "%(sys.argv[0]))

def main():
    
    if len(sys.argv) != 3:
        usage()
        exit(1)

    l1 = open(sys.argv[1], 'r').read().split("\n")[:-1]
    l2 = open(sys.argv[2], 'r').read().split("\n")[:-1]
    while "" in l1:
        l1.remove("")

    while "" in l2:
        l2.remove("")


    cmp = Cmp_fuzz(l1, l2)
    cmp.run()


if __name__ == "__main__":
    main()


