import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv(r"D:\Python\data\customer_shopping_behavior.csv")
print(df.head())

df.info()
df.describe(include='all')
df.isnull(). sum()

df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))

df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
print(df.columns)

# create age groups

bins = [0,25,40,60,100]
labels = ['Young Adult','Adult','Middle-aged','Senior']

df['age_group'] = pd.cut(
    df['age'],
    bins=bins,
    labels=labels
)
print(df[['age','age_group']].head(10))

# create purchase_frequency_days
frequency_mapping = {
    'Fortnightly': 14,
    'Weekly': 7,
    'Monthly': 30,
    'Quarterly': 90,
    'Bi-weekly': 14,
    'Annually': 365,
    'Every 3 months': 90
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)
print(df[['purchase_frequency_days','frequency_of_purchases']].head(10))

print(df[['discount_applied','promo_code_used']].head(10))

print((df['discount_applied'] == df['promo_code_used']).all())

df = df.drop('promo_code_used', axis=1)
print(df.columns)

# connecting to SQl

engine = create_engine(
    "mysql+pymysql://root:Himanshu08$@localhost/customer_behaviour"
)
df.to_sql(
    name='customer_shopping',
    con=engine,
    if_exists='replace',
    index=False
)
print("Data uploaded successfully")