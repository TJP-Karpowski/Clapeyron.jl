abstract type RKAlphaModel <: AlphaModel end

struct RKAlphaParam <: EoSParam
end


@newmodelsimple RKAlpha RKAlphaModel RKAlphaParam

export RKAlpha
function RKAlpha(components::Vector{String}; userlocations::Vector{String}=String[], verbose::Bool=false)
    params = getparams(components, ["properties/critical.csv"]; userlocations=userlocations, verbose=verbose)
    packagedparams = RKAlphaParam()
    model = RKAlpha(packagedparams, verbose=verbose)
    return model
end

function α_function(model::CubicModel,V,T,z,alpha_model::RKAlphaModel)
    Tc = model.params.Tc.values
    α = zeros(typeof(T),length(Tc))
    for i in @comps
        Tr = T/Tc[i]
        α[i] = 1 /√(Tr)
    end
    return α
end

is_splittable(::RKAlpha) = false