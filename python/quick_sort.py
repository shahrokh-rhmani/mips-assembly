def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)

# تابع اصلی
if __name__ == "__main__":
    array = [34, 7, 23, 32, 5, 62]
    print("Array before sorting:")
    print(array)
    sorted_array = quicksort(array)
    print("Array after sorting:")
    print(sorted_array)
