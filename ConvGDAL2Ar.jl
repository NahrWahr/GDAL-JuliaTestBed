begin
	using ArchGDAL
	const AG = ArchGDAL
	using Plots
	using MultivariateStats
	using Statistics
end

begin
	using FileIO
	using NPZ
	using DelimitedFiles
	using JLD2
end

function Flatten(Data::Array)::Matrix
	a,b,c =size(Data)
	Out = reshape(Data, a*b, c)
	return Out
end

function Discard0(X::Matrix)
	Out = []
	for i in 1:size(X,1)
		if sum(X[i,:]) != 0
			push!(Out, X[i,:])
		end
	end
	Out = permutedims(hcat(Out...))
	return Out
end

function LoadTIF(str = "/home/rnarwar/Pixxel/project/testdata/Hyperion_Canada.tif")::Array{UInt8}
	Data = AG.readraster(str)
	return Data
end

function LoadData(str = "/home/rnarwar/Pixxel/project/testdata/IndARD.jld2")
	X, Index = load(str, "Data", "Index")
	return X, Index
end

struct IPixel
	Ind::CartesianIndex
	Vec::Vector{UInt8}
end

function IndexFlat(Data::Array{UInt8, 3})::Matrix{IPixel}
	a,b,c = size(Data)
	A = Vector{IPixel}(undef,0)
	for i=1:a
		for j=1:b
			push!(A, IPixel(CartesianIndex(i,j), Data[i,j,:]))
		end
	end
	A = permutedims(hcat(A...))
	return A
end

function Discard0(X::Matrix{IPixel})::Tuple{Vector{CartesianIndex}, Matrix{UInt8}}
	n = size(X,1)
	Out = Vector{Vector{UInt8}}(undef,0)
	Index = Vector{CartesianIndex{2}}(undef,0)
	for i in 1:n
		if sum(X[i].Vec) != 0
			push!(Out, X[i].Vec)
			push!(Index, X[i].Ind)
		end
	end
	Out = permutedims(hcat(Out...))
	return Index,Out
end

#Index, Data = Discard0(IndexFlat(LoadData()))
#Data = Data[:,:,setdiff(1:end, (88:108),(131:158))]; # discard 88:108 131:158
#npzwrite("/home/rnarwar/Pixxel/project/testdata/FlatARD.npz", X)
#@save "/home/rnarwar/Pixxel/project/testdata/raw.jld2" X
#@save "/home/rnarwar/Pixxel/project/testdata/IndARD.jld2" Index Data
