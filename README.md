# Alphabetic Regex

Transforms an alphabetic range to a regex expression.

## Assumptions (Until we get config)

* Uppercase letters come before their lowercase counterparts. ie A -> a
* A lowercase letter comes before the next uppercase letter. ie a -> B
* Digits come before letters. ie 9 -> a
* Other special characters follow their ASCII numbering. ie z -> _
