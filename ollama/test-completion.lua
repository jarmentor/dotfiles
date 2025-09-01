-- Test file for Ollama code completion with minuet-ai.nvim
-- Try typing some code to see ghost text suggestions

-- Function to calculate factorial
function factorial(n)
    if n == 0 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

-- Function to reverse a string
function reverseString(str)
    local reversed = ""
    for i = #str, 1, -1 do
        reversed = reversed .. str:sub(i, i)
    end
    return reversed
end

-- Test completion hints:
-- 1. Place cursor after "function factorial(n)" and press Enter
-- 2. Start typing "if" to see suggestions
-- 3. Use Ctrl+j to accept suggestions
-- 4. Use Ctrl+n/Ctrl+p to cycle through suggestions
