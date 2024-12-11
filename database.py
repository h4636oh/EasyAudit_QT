import pandas as pd

def get_indices(df, l1_value=None, l2_value=None, sl1_value=None, sl2_value=None, bl_value=None):
    """
    This function filters the DataFrame to return indices where the values in columns 'L1', 'L2', 'SL1', 'SL2', or 'BL' match the specified boolean values (True/False).
    
    Parameters:
    - df: DataFrame to filter
    - l1_value: Value to match for column 'L1' (True/False), default is None (no filter for L1)
    - l2_value: Value to match for column 'L2' (True/False), default is None (no filter for L2)
    - sl1_value: Value to match for column 'SL1' (True/False), default is None (no filter for SL1)
    - sl2_value: Value to match for column 'SL2' (True/False), default is None (no filter for SL2)
    - bl_value: Value to match for column 'BL' (True/False), default is None (no filter for BL)
    
    Returns:
    - DataFrame filtered by the specified conditions
    """
    # Apply filters for each column if specified
    if l1_value is not None:
        df = df[df['L1'] == l1_value]
    
    if l2_value is not None:
        df = df[df['L2'] == l2_value]
    
    if sl1_value is not None:
        df = df[df['SL1'] == sl1_value]
    
    if sl2_value is not None:
        df = df[df['SL2'] == sl2_value]
    
    if bl_value is not None:
        df = df[df['BL'] == bl_value]
    
    return df

def keyword_search(df, column, search_phrase):
    """
    This function performs a keyword search in a specified column of the DataFrame.
    It checks if all the words in the search phrase are present in each row of the column.
    
    Parameters:
    - df: DataFrame to search in
    - column: The column name to search in
    - search_phrase: The phrase containing multiple keywords to search for
    
    Returns:
    - DataFrame with rows that contain all the words from the search phrase in the specified column
    """
    # Split the search phrase into individual words
    keywords = search_phrase.split()
    
    # Filter rows where all the words are present in the column
    filtered_df = df[df[column].apply(lambda x: all(word.lower() in x.lower() for word in keywords) if pd.notnull(x) else False)]
    
    return filtered_df

def index_search(df, column, index_pattern):
    """
    This function searches for index patterns in a specified column of the DataFrame.
    It returns rows where the values in the column start with the given index pattern (like '1.1').
    
    Parameters:
    - df: DataFrame to search in
    - column: The column name to search in
    - index_pattern: The index pattern to search for (like '1.1')
    
    Returns:
    - DataFrame with rows where the values in the specified column start with the given index pattern
    """
    # Filter rows where the column value starts with the index pattern
    filtered_df = df[df[column].apply(lambda x: x.startswith(index_pattern) if pd.notnull(x) else False)]
    
    return filtered_df

def search(ops, search_phrase=None, moduleid=None, l1_value=None, l2_value=None, sl1_value=None, sl2_value=None, bl_value=None):
    """
    Main search function that loads data based on OS and applies various filters.
    
    Parameters:
    - os: The operating system ('windows', 'ubantu', 'redhat')
    - search_phrase: Phrase for keyword search (optional)
    - moduleid: Pattern for index-based search (optional)
    - l1_value, l2_value, sl1_value, sl2_value, bl_value: Boolean filters for respective columns (optional)
    
    Returns:
    - Array of values from the 'Moduleindex' column of the filtered DataFrame
    """
    # Load the appropriate CSV based on the operating system
    if ops == "windows":
        df = pd.read_csv("windows.csv")
    elif ops == "ubuntu":
        df = pd.read_csv("path")
    elif ops == "rhel":
        df = pd.read_csv("redhat.csv")
    else:
        raise ValueError("Unsupported OS")

    # Apply basic filters
    df_after_basic_filter = get_indices(df, l1_value, l2_value, sl1_value, sl2_value, bl_value)
    df = df_after_basic_filter

    # Apply index-based filtering if moduleid is provided
    if moduleid:
        df_after_index_filter = index_search(df=df, column="Moduleindex", index_pattern=moduleid)
        df = df_after_index_filter

    # Apply keyword search if search_phrase is provided
    if search_phrase:
        df = keyword_search(df=df, column='Description', search_phrase=search_phrase)

    # Return the 'Moduleindex' column values
    return df['Moduleindex'].values

# Example usage
index = search(ops="windows", search_phrase="password", moduleid="1.1", l1_value=True)
def moduledet(Moduleindex,ops):
    # Load the appropriate CSV based on the operating system
    if ops == "windows":
        df = pd.read_csv("windows.csv")
    elif ops == "ubantu":
        df = pd.read_csv("path")
    elif ops == "redhat":
        df = pd.read_csv("redhat.csv")
    else:
        raise ValueError("Unsupported OS")
    
    
    # return the detalis of that moduleindex in dictionary
    return df.loc[df["Moduleindex"] == Moduleindex].to_dict(orient="records")

X=moduledet("1.1.1","windows")
print(X)
    
