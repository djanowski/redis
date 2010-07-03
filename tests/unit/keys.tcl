start_server {tags {"keys"}} {
    test {SREM removing the last element in a set removes the key} {
        r sadd foo 1
        r srem foo 1

        r keys *
    } {}
    
    test {LPOP popping the last element removes the key} {
        r lpush foo 1
        r lpop foo

        r keys *
    } {}
    
    test {SET setting to an empty string removes the key} {
        r set foo {}

        r keys *
    } {}
    
    test {SET setting an existing key to an empty string marks as dirty} {
        r set foo bar
        r save
        r set foo {}

        s changes_since_last_save
    } {1}
    
    test {SET setting a new key to an empty string does not mark as dirty} {
        r save
        r set foo {}

        s changes_since_last_save
    } {0}

    test {HSET setting a new field to an empty value removes the field} {
        r hset foo field1 value1
        r hset foo field2 {}

        r hkeys foo
    } {field1}
}
