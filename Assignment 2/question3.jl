using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
using CSV
using DataFrames
path = "C:/Users/bowus/OneDrive - Emory/PhD Economics/Year 2/Time Series/Homework/Assignment 2/"
data = CSV.read(path*"ND000336Q.xls", DataFrame)

