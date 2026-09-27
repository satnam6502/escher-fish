def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b


def get_first_item(items):
    return items[0]
