• Filtering operators let you control which values emitted by the upstream publisher are sent downstream, to another operator or to the consumer.
• When you don’t care about the values themselves, and only want a completion event, ignoreOutput is your friend.
• Finding values is another sort of filtering, where you can find the first or last values to match a provided predicate using first(where:) and last(where:), respectively.
• First-style operators are lazy; they take only as many values as needed and then complete. Last-style operators are greedy and must know the full scope of the values before deciding which of the values is the last to fulfill the condition.
• You can control how many values emitted by the upstream publisher are ignored before sending values downstream by using the drop family of operators.
• Similarly, you can control how many values the upstream publisher may emit before completing by using the prefix family of operators.
