import string


def opacity_to_str(opacity: float) -> str:
    return hex(int(opacity * 255.0))[2:]


def is_color(value: str) -> bool:
    return len(value) == 6 and all([ch in string.hexdigits for ch in value])


def is_base16(value: str) -> bool:
    return (
        len(value) == 6
        and value[:4] == "base"
        and value[4] in string.hexdigits
        and value[5] in string.hexdigits
    )


# https://stackoverflow.com/a/7205672/3253026
def mergedicts(dict1: dict, dict2: dict):
    for k in set(dict1.keys()).union(dict2.keys()):
        if k in dict1 and k in dict2:
            if isinstance(dict1[k], dict) and isinstance(dict2[k], dict):
                yield (k, dict(mergedicts(dict1[k], dict2[k])))
            else:
                # If one of the values is not a dict, you can't continue merging it.
                # Value from second dict overrides one in first and we move on.
                yield (k, dict2[k])
                # Alternatively, replace this with exception raiser to alert you of value conflicts
        elif k in dict1:
            yield (k, dict1[k])
        else:
            yield (k, dict2[k])
